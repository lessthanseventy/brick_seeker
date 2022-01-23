defmodule BrickSeekerWeb.ListPartsTest do
  use BrickSeeker.FeatureCase, async: true

  feature "index links to list parts", %{session: session} do
    session
    |> visit("/")
    |> assert_has(Query.link("parts page"))
  end

  feature "list parts", %{session: session} do
    session
    |> visit("/parts")
    |> assert_has(Query.text("Listing Parts"))
  end
end
