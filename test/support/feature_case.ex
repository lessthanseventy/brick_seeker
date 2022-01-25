defmodule BrickSeeker.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import BrickSeeker.Factory
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Wallaby.Feature

      alias BrickSeeker.Repo

      alias BrickSeekerWeb.Pages.{PartsIndexPage, AutocompleteComponent}
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BrickSeeker.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(BrickSeeker.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(BrickSeeker.Repo, self())

    {:ok, session} =
      Wallaby.start_session(metadata: metadata, window_size: [width: 1920, height: 1080])

    {:ok, session: session}
  end
end
