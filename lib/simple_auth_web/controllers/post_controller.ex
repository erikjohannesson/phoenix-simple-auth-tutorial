defmodule SimpleAuthWeb.PostController do
  use SimpleAuthWeb, :controller

  alias SimpleAuth.Accounts
  alias SimpleAuth.CMS

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id}, _current_user) do
    user = Accounts.get_user!(user_id)
    posts = CMS.list_posts_by_user(user)

    render(conn, "index.html", posts: posts, user: user)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}, _current_user) do
    user = Accounts.get_user!(user_id)
    post = CMS.get_user_post(user, id)

    render(conn, "show.html", post: post, user: user)
  end

  def new(conn, _params, current_user) do
    changeset = CMS.change_post_by_user(current_user)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}, current_user) do
    case CMS.create_post_by_user(post_params, current_user) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Post created")
        |> redirect(to: user_post_path(conn, :index, current_user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    post = CMS.get_user_post(current_user, id)
    changeset = CMS.change_post(post)

    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}, current_user) do
    post = CMS.get_user_post(current_user, id)
    case CMS.update_post(post, post_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Post updated")
        |> redirect(to: user_post_path(conn, :show, current_user.id, post.id))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    CMS.get_user_post(current_user, id)
    |> CMS.delete_post

    conn
    |> put_flash(:info, "Post deleted")
    |> redirect(to: user_post_path(conn, :index, current_user.id))
  end

end