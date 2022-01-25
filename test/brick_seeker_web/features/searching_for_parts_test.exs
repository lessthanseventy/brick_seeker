defmodule BrickSeeker.SearchingForPartsTest do
  use BrickSeeker.FeatureCase, async: true
  alias Faker.Color

  feature "visiting the part index page shows the part search field", %{session: session} do
    session
    |> PartsIndexPage.visit_page()
    |> PartsIndexPage.assert_on_page()
    |> PartsIndexPage.assert_has_part_search()
  end

  feature "searching for parts by name allows selection of part from results", %{session: session} do
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
