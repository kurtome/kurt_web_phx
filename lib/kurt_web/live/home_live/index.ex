defmodule KurtWeb.HomeLive.Index do
  use KurtWeb, :live_view

  @colors [
    "pink",
    "red",
    "green",
    # "lime",
    # "amber",
    # "yellow",
    "purple",
    # "gray",
    # "stone",
    "slate",
    "orange",
    "teal",
    "emerald",
    "cyan",
    "sky",
    "blue",
    "indigo",
    "violet",
    "fuchsia",
    "rose"
  ]

  embed_templates "_*"

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> calc_color()

    {:ok, socket, layout: false}
  end

  @impl true
  def handle_params(params, _url, socket) do
    slug = params["slug"]

    socket =
      socket
      |> assign(:slug, slug)
      |> assign(:content_template, content_template(slug))
      |> set_animate_site_title(slug)

    {:noreply, socket}
  end

  defp set_animate_site_title(socket, slug) do
    first_page = socket.assigns[:first_page] == nil

    socket
    |> assign(:animate_site_title, first_page && slug == nil)
    |> assign(:first_page, first_page)
  end

  @impl true
  def handle_event("color_rand", _params, socket) do
    socket =
      socket
      |> calc_color()

    {:noreply, socket}
  end

  def selected_css_class(slug, current) do
    if slug == current do
      "selected"
    else
      ""
    end
  end

  defp content_template(slug) do
    case slug do
      "whoami" -> "_whoami"
      "résumé" -> "_resume"
      "projects" -> "_projects"
      "etcetera" -> "_etcetera"
      _ -> nil
    end
  end

  defp calc_color(conn) do
    color = Enum.random(@colors)
    assign(conn, :color, color)
  end
end
