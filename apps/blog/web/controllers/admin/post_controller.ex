defmodule Blog.Admin.PostController do
  use Blog.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, _params) do

  end
end
