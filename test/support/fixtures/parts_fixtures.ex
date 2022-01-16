defmodule BrickSeeker.PartsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BrickSeeker.Parts` context.
  """

  @doc """
  Generate a part.
  """
  def part_fixture(attrs \\ %{}) do
    {:ok, part} =
      attrs
      |> Enum.into(%{
        name: "some name",
        part_number: "some part_number"
      })
      |> BrickSeeker.Parts.create_part()

    part
  end
end
