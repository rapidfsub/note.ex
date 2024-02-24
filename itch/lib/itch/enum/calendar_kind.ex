defmodule Itch.Enum.CalendarKind do
  use Ash.Type.Enum, values: [:gregorian, :lunisolar]
end
