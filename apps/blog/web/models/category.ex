defmodule Blog.Category do
  use Blog.Web, :model

  schema "categories" do
    field :name, :string
    field :description, :string
    field :meta_title, :string
    field :meta_description, :string
    has_many :posts, Blog.Post
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :meta_title, :meta_description])
    |> validate_required([])
  end
end
