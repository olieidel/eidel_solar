defmodule EidelSolar.DataController do
  use EidelSolar.Web, :controller
  alias EidelSolar.Data

  def index(conn, _params) do
    data = Repo.all(from d in Data, order_by: [desc: :time])
    conn |> render("index.json", data: data)
  end
end
