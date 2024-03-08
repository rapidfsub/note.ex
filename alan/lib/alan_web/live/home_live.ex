defmodule AlanWeb.HomeLive do
  use Alan.Prelude
  use AlanWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    form =
      M.Post
      |> AshPhoenix.Form.for_create(:create, api: M, forms: [auto?: true])
      |> to_form()
      |> AshPhoenix.Form.add_form(:comments)
      |> AshPhoenix.Form.add_form(:comments)

    {:ok, socket |> assign(form: form)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"form" => params}, socket) do
    form = socket.assigns.form |> AshPhoenix.Form.validate(params)
    {:noreply, socket |> assign(form: form)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"form" => params}, socket) do
    socket.assigns.form
    |> AshPhoenix.Form.submit(params: params)
    |> case do
      {:ok, result} ->
        {:noreply, socket |> put_flash(:info, result.id) |> push_navigate(to: ~p"/")}

      {:error, form} ->
        {:noreply, socket |> assign(form: form)}
    end
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.form id="form" for={@form} phx-change="validate" phx-submit="save" class="flex flex-col gap-2">
      <.field field={@form[:title]} />
      <.inputs_for :let={finner} field={@form[:comments]}>
        Comment <%= finner.index %>
        <.field field={finner[:content]} />
        <.field type="switch" field={finner[:is_hidden]} />
        <.field type="switch" field={finner[:is_pinned]} />
      </.inputs_for>
      <.button>submit</.button>
    </.form>
    """
  end
end
