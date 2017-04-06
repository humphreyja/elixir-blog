defmodule Blog.Repo.Migrations.CreateAuthor do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string # if empty, use auth name
      add :email, :string #match to auth
      add :description, :string
    end

  end
end
