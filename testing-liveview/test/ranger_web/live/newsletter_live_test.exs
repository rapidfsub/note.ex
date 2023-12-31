defmodule RangerWeb.NewsletterLiveTest do
  use RangerWeb.ConnCase

  import Phoenix.LiveViewTest

  test "warns user of invalid email as user types", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/newsletter")
    invalid_email = "something"

    html =
      view
      |> form("#subscribe", %{subscription: %{email: invalid_email}})
      |> render_change()

    assert html =~ "has invalid format"
  end

  test "warns user of invalid email as user types (target event directly)", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/newsletter")
    invalid_email = "something"
    html = render_change(view, "validate", %{subscription: %{email: invalid_email}})
    assert html =~ "has invalid format"
  end
end
