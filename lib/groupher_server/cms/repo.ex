defmodule GroupherServer.CMS.Repo do
  @moduledoc false
  alias __MODULE__

  use Ecto.Schema
  import Ecto.Changeset

  alias GroupherServer.CMS

  alias CMS.{
    Author,
    Community,
    RepoComment,
    RepoContributor,
    RepoFavorite,
    RepoViewer,
    RepoLang,
    RepoCommunityFlag,
    Tag
  }

  alias Helper.HTML

  @timestamps_opts [type: :utc_datetime_usec]
  @required_fields ~w(title owner_name owner_url repo_url desc readme star_count issues_count prs_count fork_count watch_count)a
  @optional_fields ~w(origial_community_id last_sync homepage_url release_tag license)a

  @type t :: %Repo{}
  schema "cms_repos" do
    field(:title, :string)
    field(:owner_name, :string)
    field(:owner_url, :string)
    field(:repo_url, :string)

    field(:desc, :string)
    field(:homepage_url, :string)
    field(:readme, :string)

    field(:star_count, :integer)
    field(:issues_count, :integer)
    field(:prs_count, :integer)
    field(:fork_count, :integer)
    field(:watch_count, :integer)

    field(:license, :string)
    field(:release_tag, :string)
    embeds_one(:primary_language, RepoLang, on_replace: :delete)

    embeds_many(:contributors, RepoContributor, on_replace: :delete)

    field(:views, :integer, default: 0)
    belongs_to(:author, Author)
    has_many(:community_flags, {"repos_communities_flags", RepoCommunityFlag})

    # NOTE: this one is tricky, pin is dynamic changed when return by func: add_pin_contents_ifneed
    field(:pin, :boolean, default_value: false)
    field(:trash, :boolean, default_value: false)

    field(:last_sync, :utc_datetime)

    has_many(:comments, {"repos_comments", RepoComment})
    has_many(:favorites, {"repos_favorites", RepoFavorite})
    has_many(:viewers, {"repos_viewers", RepoViewer})

    many_to_many(
      :tags,
      Tag,
      join_through: "repos_tags",
      join_keys: [repo_id: :id, tag_id: :id],
      on_delete: :delete_all,
      on_replace: :delete
    )

    belongs_to(:origial_community, Community)

    many_to_many(
      :communities,
      Community,
      join_through: "communities_repos",
      on_replace: :delete
    )

    # timestamps(type: :utc_datetime)
    timestamps()
  end

  @doc false
  def changeset(%Repo{} = repo, attrs) do
    repo
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> generl_changeset
  end

  @doc false
  def update_changeset(%Repo{} = repo, attrs) do
    repo
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> generl_changeset
  end

  defp generl_changeset(content) do
    content
    |> validate_length(:title, min: 1, max: 80)
    |> cast_embed(:contributors, with: &RepoContributor.changeset/2)
    |> cast_embed(:primary_language, with: &RepoLang.changeset/2)
    |> HTML.safe_string(:readme)
  end
end
