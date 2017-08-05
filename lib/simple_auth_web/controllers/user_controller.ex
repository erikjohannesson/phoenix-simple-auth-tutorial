defmodule SimpleAuthWeb.UserController do
  use SimpleAuthWeb, :controller

  alias SimpleAuth.Accounts

  plug :scrub_params, "user" when action in [:create]

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%Accounts.User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> SimpleAuthWeb.Auth.login(user)
        |> put_flash(:info, "Created user #{user.name}")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end