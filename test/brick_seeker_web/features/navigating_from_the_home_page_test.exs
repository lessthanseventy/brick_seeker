defmodule BrickSeekerWeb.ListPartsTest do
  use BrickSeeker.FeatureCase, async: true

  alias BrickSeekerWeb.Pages.HomePage

  feature "visiting the home page links to the parts index page", %{session: session} do
    session
    |> HomePage.visit_page()
    |> HomePage.assert_can_navigate_to_part_index_path()
  end
end
