defmodule SimpleAuth.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleAuth.Accounts.User


  schema "users" do
    field :email, :string
    field :is_admin, :boolean, default: false
    field :name, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password_hash, :is_admin])
    |> validate_required([:email, :name, :password_hash, :is_admin])
  end
end
