defmodule SSO.UserPermission do
  use SSO.Web, :model

  schema "user_permissions" do
    belongs_to :client_permission, SSO.ClientPermission
    belongs_to :user, SSO.User
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :client_permission_id])
    |> validate_required([:user_id, :client_permission_id])
  end
end
