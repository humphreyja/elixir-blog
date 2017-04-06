defmodule Blog.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :description, :string
      add :content, :text
      add :meta_title, :string
      add :meta_description, :string
      add :slug, :string
      add :category_id, references(:categories)
      add :author_id, references(:authors)

      timestamps()
    end
    create index(:posts, [:category_id])
    create index(:posts, [:author_id])

  end
end
