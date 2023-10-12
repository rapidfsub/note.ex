defmodule RangerWeb.AlbumLive.IndexTest do
  use RangerWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  test "user can see previewe of picture to be uploaded", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/albums")

    view
    |> upload("moria-door.png")

    assert has_element?(view, "[data-role='image-preview]")
  end

  test "user can cancel upload", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/albums")

    view
    |> upload("moria-door.png")
    |> cancel_upload()

    refute has_element?(view, "[data-role='image-preview]")
  end

  test "user sees error when uploading too many files", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/albums")

    view
    |> upload("moria-door.png")
    |> upload("moria-door.png")
    |> upload("moria-door.png")

    assert render(view) =~ "Too many files"
  end

  test "user sees error when creating new album without name", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/albums")

    view
    |> form("#upload-form", %{album: %{name: nil}})
    |> render_change()

    assert has_element?(view, "p", "can't be blank")
  end

  defp upload(view, filename) do
    view
    |> file_input("#upload-form", :photos, [
      %{
        name: filename,
        content: File.read!("test/support/images/#{filename}"),
        type: "image/png"
      }
    ])
    |> render_upload(filename)

    view
    |> form("#upload-form")
    |> render_change()

    view
  end

  defp cancel_upload(view) do
    view
    |> element("[data-role='cancel-upload']")
    |> render_click()
  end
end
