defmodule SimpleAuthWeb.Auth do

  alias SimpleAuth.Accounts

  def login_by_email_and_password(conn, email, password) do
    case Accounts.authenticate_by_email_and_password(email, password) do
      {:ok, user} -> {:ok, login(conn, user)}
      {:error, reason} -> {:error, reason, conn}
    end
  end

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

end