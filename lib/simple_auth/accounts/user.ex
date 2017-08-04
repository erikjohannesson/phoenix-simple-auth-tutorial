defmodule SimpleAuth.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleAuth.Accounts.User


  schema "users" do
    field :email, :string
    field :is_admin, :boolean, default: false
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    has_many :posts, SimpleAuth.CMS.Post

    timestamps()
  end

@required_fields ~w(email)a
@optional_fields ~w(name is_admin)a

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
