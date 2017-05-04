defmodule EidelSolar.PageController do
  use EidelSolar.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
