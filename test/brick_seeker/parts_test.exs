defmodule BrickSeeker.PartsTest do
  use BrickSeeker.DataCase
  import BrickSeeker.Factory

  alias BrickSeeker.Parts

  describe "parts" do
    alias BrickSeeker.Parts.Part

    @invalid_attrs %{name: nil, part_number: nil}

    test "list_parts/0 returns all parts" do
      part = insert(:part)
      assert Parts.list_parts() == [part]
    end

    test "get_part!/1 returns the part with given id" do
      part = insert(:part)
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
      part = insert(:part)
      update_attrs = %{name: "some updated name", part_number: "some updated part_number"}

      assert {:ok, %Part{} = part} = Parts.update_part(part, update_attrs)
      assert part.name == "some updated name"
      assert part.part_number == "some updated part_number"
    end

    test "update_part/2 with invalid data returns error changeset" do
      part = insert(:part)
      assert {:error, %Ecto.Changeset{}} = Parts.update_part(part, @invalid_attrs)
      assert part == Parts.get_part!(part.id)
    end

    test "delete_part/1 deletes the part" do
      part = insert(:part)
      assert {:ok, %Part{}} = Parts.delete_part(part)
      assert_raise Ecto.NoResultsError, fn -> Parts.get_part!(part.id) end
    end

    test "change_part/1 returns a part changeset" do
      part = insert(:part)
      assert %Ecto.Changeset{} = Parts.change_part(part)
    end

    test "search_parts returns matching parts based on part_name, sorted by part_number" do
      match_1 = insert(:part, part_number: "2", name: "Stud large")
      match_2 = insert(:part, part_number: "1", name: "Small stud")
      _no_match_3 = insert(:part, part_number: "23", name: "Not today")

      assert [match_2, match_1] == Parts.search_parts("stu")
    end

    test "search_parts returns matching parts based on part_number, sorted by part_number" do
      match_1 = insert(:part, part_number: "12378xt")
      match_2 = insert(:part, part_number: "12345xt")
      _no_match_3 = insert(:part, part_number: "321xt")

      assert [match_2, match_1] == Parts.search_parts("123")
    end
  end
end
