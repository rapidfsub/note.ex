defmodule TakeANumberDeluxe do
  alias TakeANumberDeluxe.State

  use GenServer

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset_state)
  end

  # Server callbacks

  @impl GenServer
  def init(init_arg) do
    min_number = Keyword.get(init_arg, :min_number)
    max_number = Keyword.get(init_arg, :max_number)

    args =
      case Keyword.fetch(init_arg, :auto_shutdown_timeout) do
        {:ok, auto_shutdown_timeout} -> [min_number, max_number, auto_shutdown_timeout]
        :error -> [min_number, max_number]
      end

    case apply(State, :new, args) do
      {:ok, state} -> {:ok, state, state.auto_shutdown_timeout}
      {:error, reason} -> {:stop, reason}
    end
  end

  @impl GenServer
  def handle_call(:report_state, _from, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call(:queue_new_number, _from, state) do
    case State.queue_new_number(state) do
      {:ok, number, state} -> {:reply, {:ok, number}, state, state.auto_shutdown_timeout}
      {:error, _error} = message -> {:reply, message, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority_number}, _from, state) do
    case State.serve_next_queued_number(state, priority_number) do
      {:ok, number, state} -> {:reply, {:ok, number}, state, state.auto_shutdown_timeout}
      {:error, _error} = message -> {:reply, message, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_cast(:reset_state, state) do
    case State.new(state.min_number, state.max_number, state.auto_shutdown_timeout) do
      {:ok, state} -> {:noreply, state, state.auto_shutdown_timeout}
      {:error, _error} -> {:noreply, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  @impl GenServer
  def handle_info(_msg, state) do
    {:noreply, state, state.auto_shutdown_timeout}
  end
end
