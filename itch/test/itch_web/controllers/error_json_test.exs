defmodule ItchWeb.ErrorJSONTest do
  use ItchWeb.ConnCase, async: true

  test "renders 404" do
    assert ItchWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ItchWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
