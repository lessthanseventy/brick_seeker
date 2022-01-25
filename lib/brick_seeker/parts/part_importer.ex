defmodule BrickSeeker.Parts.PartImporter do
  import Ecto.Query

  alias BrickSeeker.Parts
  alias BrickSeeker.Repo
  alias BrickSeeker.Parts.Part

  @default_batch_size 1000

  def import_from_file(file_path, opts \\ []) do
    batch_size = Keyword.get(opts, :batch_size, @default_batch_size)

    Repo.transaction(fn ->
      file_path
      |> stream_rows()
      |> transform_rows()
      |> validate_rows()
      |> batch_rows(batch_size)
      |> upsert_batches()
      |> case do
        results when is_list(results) -> Repo.rollback(results)
        inserted_count -> inserted_count
      end
    end)
  end

  defp stream_rows(file_path) do
    file_path
    |> File.stream!()
    |> CSV.decode(headers: true, strip_fields: true)
  end

  defp transform_rows(rows) do
    Stream.map(rows, &transform_row/1)
  end

  defp transform_row({:error, message}), do: {:error, "CSV Validation Error: " <> message}

  defp transform_row({:ok, %{"part_num" => part_number, "name" => name}}) do
    {:ok,
     %{
       part_number: part_number,
       name: name,
       inserted_at: DateTime.utc_now(),
       updated_at: DateTime.utc_now()
     }}
  end

  defp validate_rows(rows) do
    rows
    |> Stream.with_index()
    |> Stream.map(&validate_row/1)
  end

  defp validate_row({{:ok, part_map}, index}) do
    case Parts.change_part(%Part{}, part_map) do
      %{errors: [_ | _]} = changeset -> {:error, format_errors_for_row(changeset, index + 2)}
      _ -> {:ok, part_map}
    end
  end

  defp validate_row({error_row, _index}), do: error_row

  defp format_errors_for_row(changeset, row_number) do
    messages =
      changeset
      |> Ecto.Changeset.traverse_errors(fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)
      |> Enum.reduce([], fn {field_name, errors}, acc ->
        messages_for_field =
          errors
          |> Enum.map(fn error -> "#{field_name} #{error}" end)

        acc ++ messages_for_field
      end)
      |> Enum.join(", ")

    "Model Validation Error: " <> messages <> " on line #{row_number}"
  end

  defp batch_rows(part_rows, batch_size) do
    Stream.chunk_every(part_rows, batch_size)
  end

  defp upsert_batches(part_batches) do
    Enum.reduce(part_batches, 0, fn part_batch, acc ->
      part_batch
      |> Enum.reduce({[], []}, fn part_row, {valid_rows, invalid_rows} ->
        case part_row do
          {:ok, valid_row} -> {[valid_row | valid_rows], invalid_rows}
          {:error, invalid_row} -> {valid_rows, [invalid_row | invalid_rows]}
        end
      end)
      |> then(fn {valid_rows, invalid_rows} ->
        {Enum.reverse(valid_rows), Enum.reverse(invalid_rows)}
      end)
      |> maybe_upsert_batch(acc)
    end)
  end

  defp maybe_upsert_batch({_, invalid_rows}, acc) when is_list(acc), do: acc ++ invalid_rows

  defp maybe_upsert_batch({_, [_ | _] = invalid_rows}, _acc), do: invalid_rows

  defp maybe_upsert_batch({valid_rows, _}, acc) do
    {inserted_count, _} = insert_all_parts(valid_rows)
    acc + inserted_count
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
end
