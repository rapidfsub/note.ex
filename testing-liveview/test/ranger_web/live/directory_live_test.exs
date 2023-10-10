defmodule RangerWeb.DirectoryLiveTest do
  use RangerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias Ranger.Directory

  test "user is directed to member information", %{conn: conn} do
    member = Directory.get_by(name: "Aragorn")
    {:ok, view, _html} = live(conn, ~p"/directory")

    view
    |> element("[data-role=member]", "Aragorn")
    |> render_click()

    assert_patch(view, ~p"/directory/#{member.id}")
  end

  test "user can see member information upon selection", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/directory")

    view
    |> element("[data-role=member]", "Aragorn")
    |> render_click()

    assert has_element?(view, "#active-member", "Aragorn")
  end

  test "user can visit specific member", %{conn: conn} do
    member = Directory.get_by(name: "Aragorn")
    {:ok, view, _html} = live(conn, ~p"/directory/#{member.id}")
    assert has_element?(view, "#active-member", "Aragorn")
  end
end
