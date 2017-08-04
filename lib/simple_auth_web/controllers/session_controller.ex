defmodule SimpleAuthWeb.SessionController do
  use SimpleAuthWeb, :controller

  alias SimpleAuth.Accounts

  plug :scrub_params, "session" when action in [:create]

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email,
                                    "password" => password}}) do
    # TBD
  end

  def delete(conn, _) do
    # TBD
  end
end