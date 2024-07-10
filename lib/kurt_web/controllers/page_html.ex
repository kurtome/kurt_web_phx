defmodule KurtWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use KurtWeb, :html

  embed_templates "page_html/*"

  def selected_css_class(conn, path, class) do
    request_path = URI.decode(conn.request_path)

    if request_path == path do
      class
    else
      nil
    end
  end

  def not_selected_css_class(conn, path, class) do
    request_path = URI.decode(conn.request_path)

    if request_path != path and request_path != "/" do
      class
    else
      nil
    end
  end
end
