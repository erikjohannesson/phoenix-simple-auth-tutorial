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

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
