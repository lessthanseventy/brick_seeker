defmodule BrickSeeker.Parts.Part do
  use BrickSeeker.Schema
  import Ecto.Changeset

  schema "parts" do
    field :name, :string
    field :part_number, :string

    timestamps()
  end

  @doc false
  def changeset(part, attrs) do
    part
    |> cast(attrs, [:part_number, :name])
    |> validate_required([:part_number, :name])
    |> unique_constraint(:part_number)
  end
end
