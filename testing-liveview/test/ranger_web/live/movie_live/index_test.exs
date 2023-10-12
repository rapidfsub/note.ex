defmodule RangerWeb.MovieLive.IndexTest do
  alias Ranger.CloudinaryUpload

  use RangerWeb.ConnCase

  import Phoenix.LiveViewTest

  test "generates correct metadata for external upload", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/movies")

    {:ok, %{entries: entries}} =
      view
      |> file_input("#upload-form", :posters, [
        %{
          name: "fellowship-poster.jpg",
          content: File.read!("test/support/images/fellowship-poster.jpg"),
          type: "image/jpeg"
        }
      ])
      |> preflight_upload()

    for {_k, v} <- entries do
      assert v.uploader == "Cloudinary"
      assert v.url =~ CloudinaryUpload.image_api_url(cloud_name())
      assert v.fields[:folder] == "testing-liveview"
      assert is_binary(v.fields[:public_id])
      refute String.ends_with?(v.fields[:public_id], "jpg")
    end
  end

  test "user can create movie and stores correct URLs", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/movies")

    {:ok, show_view, _show_html} =
      view
      |> upload("fellowship-poster.jpg")
      |> create_movie("The Fellowship of the Ring")
      |> follow_redirect(conn)

    assert has_element?(show_view, "h2", "The Fellowship of the Ring")
    assert has_element?(show_view, "[data-role='image']")
    assert hd(last_movie().poster_urls) =~ CloudinaryUpload.image_url(cloud_name())
  end

  defp last_movie() do
    Ecto.Query.last(Ranger.Movie) |> Ranger.Repo.one()
  end

  defp cloud_name() do
    Application.get_env(:ranger, :cloudinary)[:cloud_name]
  end

  defp upload(view, filename) do
    view
    |> file_input("#upload-form", :posters, [
      %{
        name: filename,
        content: File.read!("test/support/images/#{filename}"),
        type: "image/jpeg"
      }
    ])
    |> render_upload(filename)

    view
    |> form("#upload-form")
    |> render_change()

    view
  end

  defp create_movie(view, name) do
    view
    |> form("#upload-form", %{movie: %{name: name}})
    |> render_submit()
  end
end
