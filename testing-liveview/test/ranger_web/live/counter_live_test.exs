defmodule RangerWeb.CounterLiveTest do
  use RangerWeb.ConnCase

  import Phoenix.LiveViewTest

  test "user can increase counter", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/counter")

    view
    |> element("#increment")
    |> render_click()

    assert has_element?(view, ~s"#count", "1")
  end

  test "user can increase counter (uses HTML)", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/counter")

    html =
      view
      |> element("#increment")
      |> render_click()

    assert html =~ "1"
  end

  test "user can increase counter (target event directly)", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/counter")

    view
    |> render_click("increase")

    assert has_element?(view, ~s"#count", "1")
  end
end
