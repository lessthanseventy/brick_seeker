defmodule BrickSeeker.PartsTest do
  use BrickSeeker.DataCase

  alias BrickSeeker.Parts

  describe "parts" do
    alias BrickSeeker.Parts.Part

    import BrickSeeker.PartsFixtures

    @invalid_attrs %{name: nil, part_number: nil}

    test "list_parts/0 returns all parts" do
      part = part_fixture()
      assert Parts.list_parts() == [part]
    end

    test "get_part!/1 returns the part with given id" do
      part = part_fixture()
      assert Parts.get_part!(part.id) == part
    end

    test "create_part/1 with valid data creates a part" do
      valid_attrs = %{name: "some name", part_number: "some part_number"}

      assert {:ok, %Part{} = part} = Parts.create_part(valid_attrs)
      assert part.name == "some name"
      assert part.part_number == "some part_number"
    end

    test "create_part/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parts.create_part(@invalid_attrs)
    end

    test "update_part/2 with valid data updates the part" do
      part = part_fixture()
      update_attrs = %{name: "some updated name", part_number: "some updated part_number"}

      assert {:ok, %Part{} = part} = Parts.update_part(part, update_attrs)
      assert part.name == "some updated name"
      assert part.part_number == "some updated part_number"
    end

    test "update_part/2 with invalid data returns error changeset" do
      part = part_fixture()
      assert {:error, %Ecto.Changeset{}} = Parts.update_part(part, @invalid_attrs)
      assert part == Parts.get_part!(part.id)
    end

    test "delete_part/1 deletes the part" do
      part = part_fixture()
      assert {:ok, %Part{}} = Parts.delete_part(part)
      assert_raise Ecto.NoResultsError, fn -> Parts.get_part!(part.id) end
    end

    test "change_part/1 returns a part changeset" do
      part = part_fixture()
      assert %Ecto.Changeset{} = Parts.change_part(part)
    end
  end
end
