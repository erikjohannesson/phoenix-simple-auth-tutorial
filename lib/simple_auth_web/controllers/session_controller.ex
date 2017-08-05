defmodule SimpleAuthWeb.SessionController do
  use SimpleAuthWeb, :controller

  alias SimpleAuth.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email,
                                    "password" => password}}) do
    case Accounts.authenticate_by_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> login(user)
        |> put_flash(:info, "You’re now logged in!")
        |> redirect(to: page_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: page_path(conn, :index))
  end

  defp login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

  defp logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

end