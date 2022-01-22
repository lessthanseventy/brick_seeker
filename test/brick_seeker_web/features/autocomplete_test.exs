defmodule BrickSeekerWeb.AutoCompleteTest do

  feature "list parts", %{session: session} do
    session
    |> visit("/parts")
    |> assert_has(Query.text("Listing Parts"))
  end

  feature "new parts", %{session: session} do
    session
    |> visit("/parts")
    |> click(data("test", "new-part"))
    |> assert_has(css("#modal"))
  end
end
