defmodule SSO.Repo.Migrations.CreateClient do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :name, :string
      add :client_key, :string
      add :sign_in_redirect_url, :string
      add :sign_out_redirect_url, :string
      add :home_page, :string
      add :secret, :string
      timestamps
    end
    create unique_index(:clients, [:client_key])

    create table(:client_permissions) do
      add :client_id, references(:clients)
      add :name, :string
    end
    create index(:client_permissions, [:client_id]) 
  end
end
