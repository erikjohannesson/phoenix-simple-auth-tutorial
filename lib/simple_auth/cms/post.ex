defmodule SimpleAuth.CMS.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleAuth.CMS.Post


  schema "posts" do
    field :body, :string
    field :title, :string
    belongs_to :user, SimpleAuth.Accounts.User

    timestamps()
  end

@required_fields ~w(title)a
@optional_fields ~w(body)a

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
  end
end
