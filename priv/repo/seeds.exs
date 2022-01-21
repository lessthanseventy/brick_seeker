# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BrickSeeker.Repo.insert!(%BrickSeeker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

require Logger

parts_file = Path.join(File.cwd!(), "priv/csv_files/parts.csv")
{:ok, number_of_inserts} = BrickSeeker.Parts.PartImporter.import_from_file(parts_file)
Logger.info("Imported #{number_of_inserts} parts from CSV")
