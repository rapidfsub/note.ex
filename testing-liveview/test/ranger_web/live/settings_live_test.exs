defmodule RangerWeb.SettingsLiveTest do
  alias Ranger.{Repo, User}

  use RangerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders user's information", %{conn: conn} do
    user = create_user()
    {:ok, _view, html} = live(conn, ~p"/users/#{user}/settings")
    assert html =~ user.name
    assert html =~ user.email
  end

  test "users can edit their name", %{conn: conn} do
    user = create_user(%{name: "Frodo"})
    {:ok, view, _html} = live(conn, ~p"/users/#{user}/settings")

    view
    |> element("#name")
    |> render_click()

    view
    |> form("#name-form", %{name: "Bilbo"})
    |> render_submit()

    assert has_element?(view, "#name", "Bilbo")
  end

  test "users can edit their email", %{conn: conn} do
    user = create_user(%{email: "frodo@example.com"})
    {:ok, view, _html} = live(conn, ~p"/users/#{user}/settings")

    view
    |> element("#email")
    |> render_click()

    view
    |> form("#email-form", %{email: "frodo@fellowship.com"})
    |> render_submit()

    assert has_element?(view, "#email", "frodo@fellowship.com")
  end

  defp create_user(attrs \\ %{}) do
    %{name: "somename", email: "random@example.com"}
    |> Map.merge(attrs)
    |> User.changeset()
    |> Repo.insert!()
  end
end
