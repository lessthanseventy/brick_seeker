defmodule BrickSeeker.Parts.PartImporterTest do
  use BrickSeeker.DataCase

  alias BrickSeeker.Parts.PartImporter
  alias BrickSeeker.Parts.Part
  alias BrickSeeker.Repo

  describe "import_from_file/1" do
    test "with a valid file it imports the correct number of records" do
      parts_file = Path.join(File.cwd!(), "test/fixtures/parts.csv")
      assert {:ok, 10} = PartImporter.import_from_file(parts_file)
    end

    test "with an invalid file it shows an error message for the each of the invalid lines" do
      parts_file = Path.join(File.cwd!(), "test/fixtures/invalid_parts.csv")

      assert {:error,
              [
                "CSV Validation Error: Row has length 4 - expected length 3 on line 3",
                "CSV Validation Error: Row has length 2 - expected length 3 on line 11"
              ]} = PartImporter.import_from_file(parts_file, batch_size: 2)
    end

    test "with an invalid file it does not change the database" do
      parts_file = Path.join(File.cwd!(), "test/fixtures/invalid_parts.csv")

      assert {:error, _} = PartImporter.import_from_file(parts_file)
      assert 0 == Repo.aggregate(Part, :count)
    end

    test "with a syntactically valid file but missing part data it does not change the database" do
      parts_file = Path.join(File.cwd!(), "test/fixtures/parts_missing_data.csv")

      assert {:error,
              [
                "Model Validation Error: name can't be blank on line 3",
                "Model Validation Error: part_number can't be blank on line 10",
                "Model Validation Error: name can't be blank, part_number can't be blank on line 11"
              ]} = PartImporter.import_from_file(parts_file, batch_size: 2)

      assert 0 == Repo.aggregate(Part, :count)
    end

    test "with syntax errors and missing part data it shows both kinds of errors" do
      parts_file =
        Path.join(File.cwd!(), "test/fixtures/invalid_syntax_and_parts_missing_info.csv")

      assert {:error,
              [
                "CSV Validation Error: Row has length 4 - expected length 3 on line 3",
                "Model Validation Error: name can't be blank on line 10"
              ]} = PartImporter.import_from_file(parts_file, batch_size: 2)

      assert 0 == Repo.aggregate(Part, :count)
    end

    test "imports are idempotent and perform upserts" do
      parts_file = Path.join(File.cwd!(), "test/fixtures/parts.csv")
      assert {:ok, 10} = PartImporter.import_from_file(parts_file)
      assert {:ok, 10} = PartImporter.import_from_file(parts_file)
      assert 10 == Repo.aggregate(Part, :count)
    end
  end
end
