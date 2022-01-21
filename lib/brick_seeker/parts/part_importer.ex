defmodule BrickSeeker.Parts.PartImporter do
  import Ecto.Query

  alias BrickSeeker.Repo
  alias BrickSeeker.Parts.Part

  @line_number_offset 2

  def import_from_file(file_path) do
    Repo.transaction(fn ->
      file_path
      |> batch_rows()
      |> transform_rows()
      |> Enum.reduce(0, fn parts_batch, acc ->
        case parts_batch do
          %{invalid_rows: [_ | _] = invalid_rows} ->
            Repo.rollback(invalid_rows)

          %{valid_rows: valid_rows} ->
            {inserted_count, _} = insert_all_parts(valid_rows)
            acc + inserted_count
        end
      end)
    end)
  end

  defp insert_all_parts(valid_rows) do
    on_conflict_query =
      from(
        part in Part,
        update: [
          set: [
            name: fragment("EXCLUDED.name"),
            updated_at: fragment("EXCLUDED.updated_at")
          ]
        ]
      )

    Repo.insert_all(
      Part,
      valid_rows,
      conflict_target: :part_number,
      on_conflict: on_conflict_query
    )
  end

  defp batch_rows(file_path) do
    file_path
    |> File.stream!()
    |> CSV.decode(headers: true, strip_fields: true)
    |> Stream.with_index()
    |> Stream.chunk_every(500)
  end

  defp transform_rows(rows) do
    Stream.map(rows, fn batch ->
      Enum.reduce(batch, %{valid_rows: [], invalid_rows: []}, fn {row, index}, acc ->
        case row do
          {:ok, %{"part_num" => part_number, "name" => name}} ->
            %{
              acc
              | valid_rows: [
                  %{
                    part_number: part_number,
                    name: name,
                    inserted_at: DateTime.utc_now(),
                    updated_at: DateTime.utc_now()
                  }
                  | acc.valid_rows
                ]
            }

          {:error, message} ->
            %{acc | invalid_rows: [{index + @line_number_offset, message} | acc.invalid_rows]}
        end
      end)
    end)
  end
end
