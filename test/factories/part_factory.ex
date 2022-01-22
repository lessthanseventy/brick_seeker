defmodule BrickSeeker.PartFactory do
  defmacro __using__(_opts) do
    quote do
      def part_factory do
        %BrickSeeker.Parts.Part{
          name: Faker.Commerce.product_name(),
          part_number:
            "#{100_000 + :rand.uniform(99999)}#{String.downcase(Faker.String.base64(5))}"
        }
      end
    end
  end
end
