defmodule BrickSeeker.Factory do
  use ExMachina.Ecto, repo: BrickSeeker.Repo
  use BrickSeeker.PartFactory
end
