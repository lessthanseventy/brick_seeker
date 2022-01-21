defmodule BrickSeeker.Parts.PartImporter do
  alias BrickSeeker.Repo

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
            elem(Repo.insert_all(BrickSeeker.Parts.Part, valid_rows), 0) + acc
        end
      end)
    end)
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
