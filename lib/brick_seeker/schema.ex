defmodule BrickSeeker.Schema do
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
