defmodule RangerWeb.AboutComponentsTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest

  import RangerWeb.AboutComponents

  describe "badge" do
    test "renders content in badge (render_component)" do
      component = render_component(&badge/1, type: "hobbit")
      assert component =~ "hobbit"
    end

    test "renders content in badge (HEEX)" do
      assigns = %{}

      component =
        ~H"""
        <.badge type="hobbit" />
        """
        |> rendered_to_string()

      assert component =~ "hobbit"
    end

    test "renders green badge for hobbits" do
      assigns = %{}

      component =
        ~H"""
        <.badge type="hobbit" />
        """
        |> rendered_to_string()

      assert component =~ "bg-green"
    end

    test "renders red badge for wizards" do
      assigns = %{}

      component =
        ~H"""
        <.badge type="wizard" />
        """
        |> rendered_to_string()

      assert component =~ "bg-red"
    end
  end
end
