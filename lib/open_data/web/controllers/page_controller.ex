defmodule OpenData.Web.PageController do
  use OpenData.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
