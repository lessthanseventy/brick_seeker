defmodule BrickSeeker.Repo.Migrations.CreateParts do
  use Ecto.Migration

  def change do
    create table(:parts) do
      add :part_number, :string
      add :name, :string

      timestamps()
    end
  end
end
