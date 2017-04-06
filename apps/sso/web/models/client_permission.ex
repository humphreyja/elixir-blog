defmodule SSO.ClientPermission do
  use SSO.Web, :model

  schema "client_permissions" do
    belongs_to :client, SSO.Client
    field :name, :string
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :client_id])
    |> validate_required([:name, :client_id])
  end
end
