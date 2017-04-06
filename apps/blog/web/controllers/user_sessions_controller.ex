defmodule Blog.UserSessionsController do
  use Blog.Web, :controller
  import Logger

  def new(%{assigns: %{current_user: current_user}} = conn, _) do
    conn
    |> put_flash(:notice, "You're already signed in")
    |> redirect(to: "/")
    |> halt
  end

  def new(conn, %{"token" => token}) do
    case JWT.valid_token(token) do
      {:ok, claims} ->
        sign_in_and_redirect(conn, claims)
      {:error, error} ->
        Logger.info("Invalid Token: #{inspect error}")
        flash_and_redirect(conn)
    end
  end

  def new(conn, _params) do
    sso_sign_in_redirect(conn)
  end

  def delete(conn, %{"token" => token}) do
    case JWT.valid_token(token) do
      {:ok, claims} ->
        sign_out_and_redirect(conn)
      {:error, error} ->
        Logger.info("Invalid Token: #{inspect error}")
        flash_and_redirect(conn)
    end
  end

  def delete(conn, _params) do
    conn
    |> get_session(:signing_out_current_user)
    |> sign_out_or_sso_redirect(conn)
  end

  defp sign_out_or_sso_redirect(nil, conn) do
    conn
    |> put_session(:signing_out_current_user, true)
    |> redirect(external: Application.get_env(:blog, :authorization_server_sign_out, ""))
    |> halt
  end

  defp sign_out_or_sso_redirect(_, conn) do
    sign_out_and_redirect(conn)
  end

  defp sign_out_and_redirect(conn) do
    conn
    |> delete_session(:current_user)
    |> delete_session(:signing_out_current_user)
    |> put_flash(:info, "Signed out successfully")
    |> redirect(to: "/")
    |> halt
  end

  defp sign_in_and_redirect(conn, user) do
    sign_in_path = Application.get_env(:blog, :authorization_server_sign_in, "")
    path = case get_session(conn, :authorization_pre_redirect_route) do
      ^sign_in_path -> "/"
      nil -> "/"
      other -> other
    end
    conn
    |> put_session(:current_user, user)
    |> put_flash(:info, "Signed in successfully")
    |> delete_session(:authorization_pre_redirect_route)
    |> redirect(to: path)
    |> halt
  end


  defp flash_and_redirect(conn) do
    conn
    |> put_flash(:error, "Invalid Access")
    |> redirect(to: "/")
    |> halt
  end

  defp sso_sign_in_redirect(conn) do
    conn
    |> put_session(:authorization_pre_redirect_route, conn.request_path)
    |> redirect(external: Application.get_env(:blog, :authorization_server_sign_in, ""))
    |> halt
  end


end
