defmodule RangerWeb.AvatarLiveTest do
  alias Ranger.Gravatar

  use RangerWeb.ConnCase

  import Phoenix.LiveViewTest

  test "renders avatar for given email", %{conn: conn} do
    email = "frodo@shire.com"
    avatar_url = Gravatar.generate(email)
    {:ok, _view, html} = live(conn, "/avatar/#{email}")
    assert html =~ avatar_url
  end

  test "renders avatar HTML", %{conn: conn} do
    email = "frodo@shire.com"
    avatar_url = Gravatar.generate(email)
    {:ok, _view, html} = live(conn, "/avatar/#{email}")
    avatar = ~s[<img class="avatar" src="#{avatar_url}"]
    assert html =~ avatar
  end

  test "renders avatar image for given email", %{conn: conn} do
    email = "frodo@shire.com"
    avatar_url = Gravatar.generate(email)
    {:ok, view, _html} = live(conn, "/avatar/#{email}")
    assert has_element?(view, ~s/img[src*="#{avatar_url}"]/)
  end

  test "renders avatar element for given email", %{conn: conn} do
    email = "frodo@shire.com"
    avatar_url = Gravatar.generate(email)
    {:ok, view, _html} = live(conn, "/avatar/#{email}")
    avatar = element(view, ~s/img[src*="#{avatar_url}"]/)
    assert has_element?(avatar)
  end
end
