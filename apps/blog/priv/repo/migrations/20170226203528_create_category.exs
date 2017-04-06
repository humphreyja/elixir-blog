defmodule Blog.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :description, :string
      add :meta_title, :string
      add :meta_description, :string
    end
  end
end
