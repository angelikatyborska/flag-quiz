defmodule FlagQuizWeb.PageController do
  use FlagQuizWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
