defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  defmodule State do
    defstruct balance: 0, closed: false
  end

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account
  def open() do
    {:ok, account} = Agent.start(fn -> %State{} end)
    account
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account) :: any
  def close(account) do
    Agent.update(account, fn state -> %{state | closed: true} end)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer | {:error, :account_closed}
  def balance(account) do
    Agent.get(account, fn
      %State{closed: true} -> {:error, :account_closed}
      state -> state.balance
    end)
  end

  @doc """
  Add the given amount to the account's balance.
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(_account, amount) when amount <= 0 do
    {:error, :amount_must_be_positive}
  end

  def deposit(account, amount) do
    Agent.get_and_update(account, fn
      %State{closed: true} = state -> {{:error, :account_closed}, state}
      state -> {:ok, %{state | balance: state.balance + amount}}
    end)
  end

  @doc """
  Subtract the given amount from the account's balance.
  """
  @spec withdraw(account, integer) ::
          :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(_account, amount) when amount <= 0 do
    {:error, :amount_must_be_positive}
  end

  def withdraw(account, amount) do
    Agent.get_and_update(account, fn
      %State{closed: true} = state ->
        {{:error, :account_closed}, state}

      state ->
        if state.balance < amount do
          {{:error, :not_enough_balance}, state}
        else
          {:ok, %{state | balance: state.balance - amount}}
        end
    end)
  end
end
