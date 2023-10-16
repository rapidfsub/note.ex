defmodule CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """
  use GenServer

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    GenServer.start_link(__MODULE__, capacity)
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    GenServer.call(buffer, :read)
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    GenServer.call(buffer, {:write, item})
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    GenServer.call(buffer, {:overwrite, item})
  end

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    GenServer.call(buffer, :clear)
  end

  defmodule State do
    @enforce_keys [:capacity, :index, :count, :buffer]
    defstruct @enforce_keys

    def new(capacity) do
      %__MODULE__{capacity: capacity, index: 0, count: 0, buffer: %{}}
    end
  end

  def init(capacity) do
    {:ok, State.new(capacity)}
  end

  def handle_call(
        :read,
        _from,
        %State{capacity: capacity, index: index, count: count, buffer: buffer} = state
      ) do
    if count > 0 do
      result = Map.fetch!(buffer, index)
      buffer = Map.delete(buffer, index)
      index = next_index(index, 1, capacity)
      {:reply, {:ok, result}, %{state | index: index, count: count - 1, buffer: buffer}}
    else
      {:reply, {:error, :empty}, state}
    end
  end

  def handle_call(
        {command, item},
        _from,
        %State{capacity: capacity, index: index, count: count, buffer: buffer} = state
      )
      when command in [:write, :overwrite] do
    if count < capacity do
      buffer = Map.put(buffer, next_index(index, count, capacity), item)
      {:reply, :ok, %{state | index: index, count: count + 1, buffer: buffer}}
    else
      case command do
        :write ->
          {:reply, {:error, :full}, state}

        :overwrite ->
          buffer = Map.put(buffer, next_index(index, count, capacity), item)
          index = next_index(index, 1, capacity)
          {:reply, :ok, %{state | index: index, count: count, buffer: buffer}}
      end
    end
  end

  def handle_call(:clear, _from, %State{} = state) do
    {:reply, :ok, %{state | index: 0, count: 0, buffer: %{}}}
  end

  defp next_index(index, count, capacity) do
    rem(index + count, capacity)
  end
end
