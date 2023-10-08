# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct @enforce_keys
end

defmodule CommunityGarden do
  @enforce_keys [:plots, :id_seq]
  defstruct @enforce_keys

  def start(opts \\ []) do
    Agent.start(&init/0, opts)
  end

  defp init() do
    %__MODULE__{plots: [], id_seq: 1}
  end

  def list_registrations(pid) do
    Agent.get(pid, & &1.plots)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn %__MODULE__{plots: plots, id_seq: id_seq} = state ->
      plot = %Plot{plot_id: id_seq, registered_to: register_to}
      {plot, %{state | plots: [plot | plots], id_seq: id_seq + 1}}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn %__MODULE__{plots: plots} = state ->
      %{state | plots: Enum.filter(plots, &(&1.plot_id != plot_id))}
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn %__MODULE__{plots: plots} ->
      Enum.find(plots, {:not_found, "plot is unregistered"}, &(&1.plot_id == plot_id))
    end)
  end
end
