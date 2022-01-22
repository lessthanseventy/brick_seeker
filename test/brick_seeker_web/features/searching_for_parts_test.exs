defmodule BrickSeeker.SearchingForPartsTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature
  import BrickSeeker.Factory

  alias BrickSeekerWeb.Pages.{PartsIndexPage, AutocompleteComponent}
  alias Faker.Color

  feature "searching for parts by name", %{session: session} do
    insert_list(5, :part)
    Enum.each(0..4, fn x -> insert(:part, name: "#{Color.name()} Stud #{x}") end)
    part_to_select = insert(:part, name: "Spectacular Stud 1x1")

    session
    |> PartsIndexPage.visit_page()
    |> AutocompleteComponent.within("parts", fn component ->
      component
      |> AutocompleteComponent.search("Stud")
      |> AutocompleteComponent.select_from_search(part_to_select)
    end)
    |> PartsIndexPage.assert_part_selected(part_to_select)
  end
end
