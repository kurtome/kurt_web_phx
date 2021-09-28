defmodule KurtWeb.PageView do
  use KurtWeb, :view

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
