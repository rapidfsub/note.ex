defmodule CounterApiTest do
  use ExUnit.Case

  test "use counter thruough API" do
    pid = Counter.start(0)
    assert Counter.state(pid) == 0

    Counter.tick(pid)
    Counter.tick(pid)

    assert Counter.state(pid) == 2
  end
end
