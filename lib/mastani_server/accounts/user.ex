defmodule MastaniServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias MastaniServer.Accounts.User
  alias MastaniServer.CMS

  schema "users" do
    field(:username, :string)
    field(:nickname, :string)
    field(:bio, :string)
    field(:company, :string)

    many_to_many(
      :starredPosts,
      CMS.Post,
      join_through: "users_posts_stars",
      on_delete: :delete_all
    )

    timestamps()
  end

  @required_fields ~w(username)a
  @optional_fields ~w(username nickname bio company)a

  @doc false
  def changeset(%User{} = user, attrs) do
    # |> cast(attrs, [:username, :nickname, :bio, :company])
    # |> validate_required([:username])
    # |> cast(attrs, @required_fields, @optional_fields)
    user
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:username, max: 5)
    |> unique_constraint(:username)
  end
end
