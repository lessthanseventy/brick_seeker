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
                "Row has length 4 - expected length 3 on line 3",
                "Row has length 2 - expected length 3 on line 11"
              ]} = PartImporter.import_from_file(parts_file, batch_size: 2)
    end

    test "with an invalid file it does not change the database" do
      parts_file = Path.join(File.cwd!(), "test/fixtures/invalid_parts.csv")

      assert {:error, _} = PartImporter.import_from_file(parts_file)
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
