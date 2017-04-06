defmodule Blog.Author do
  use Blog.Web, :model

  schema "authors" do
    field :name, :string # if empty, use auth name
    field :email, :string #match to auth
    field :description, :string
    has_many :posts, Blog.Post
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :description])
    |> validate_required([])
  end
end
