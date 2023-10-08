defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct @enforce_keys ++ [battery_percentage: 100, distance_driven_in_meters: 0]

  def new(nickname \\ "none") do
    %__MODULE__{nickname: nickname}
  end

  def display_distance(%__MODULE__{distance_driven_in_meters: distance}) do
    "#{distance} meters"
  end

  def display_battery(%__MODULE__{battery_percentage: battery}) when battery > 0 do
    "Battery at #{battery}%"
  end

  def display_battery(%__MODULE__{}) do
    "Battery empty"
  end

  def drive(%__MODULE__{battery_percentage: battery} = remote_car) when battery > 0 do
    %{
      remote_car
      | battery_percentage: battery - 1,
        distance_driven_in_meters: remote_car.distance_driven_in_meters + 20
    }
  end

  def drive(%__MODULE__{} = remote_car) do
    remote_car
  end
end
