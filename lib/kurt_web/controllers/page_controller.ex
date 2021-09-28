defmodule KurtWeb.PageController do
  use KurtWeb, :controller

  @colors [
    "pink",
    "red",
    "green",
    # "yellow",
    "purple",
    # "gray",
    "orange",
    "teal",
    # "blue",
    "indigo"
  ]

  def index(conn, params) do
    conn
    |> assign(:content_template, content_template(params))
    |> calc_color()
    |> render("index.html")
  end

  def color_rand(conn, _params) do
    conn
    |> delete_resp_cookie("site_color")
    |> redirect(to: "/")
  end

  defp content_template(params) do
    case params["slug"] do
      "whoami" -> "_whoami.html"
      "résumé" -> "_resume.html"
      "projects" -> "_projects.html"
      "etcetera" -> "_etcetera.html"
      _ -> nil
    end
  end

  defp calc_color(conn) do
    cookie_color =
      conn
      |> fetch_cookies()
      |> Map.get(:req_cookies)
      |> Map.get("site_color")

    {conn, color} =
      case cookie_color do
        nil ->
          c = Enum.random(@colors)
          {put_resp_cookie(conn, "site_color", c, max_age: 24 * 60 * 60), c}

        _ ->
          {conn, cookie_color}
      end

    assign(conn, :color, color)
  end
end
