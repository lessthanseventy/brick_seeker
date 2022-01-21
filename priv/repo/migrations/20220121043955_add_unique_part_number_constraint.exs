defmodule BrickSeeker.Repo.Migrations.AddUniquePartNumberConstraint do
  use Ecto.Migration

  def change do
    create(unique_index(:parts, :part_number))
  end
end
