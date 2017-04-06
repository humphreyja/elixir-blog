defmodule Blog.Post do
  use Blog.Web, :model

  schema "posts" do
    field :title, :string
    field :description, :string
    field :content, :string
    field :meta_title, :string
    field :meta_description, :string
    field :slug, :string
    belongs_to :category, Blog.Post
    belongs_to :author, Blog.Author
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :content, :meta_title, :meta_description, :slug, :category_id, :author_id])
    |> validate_required([:slug])
  end
end
