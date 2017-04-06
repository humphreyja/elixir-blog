defmodule Blog.Helpers.Authorization do
  defmacro __using__(_) do
    quote do
      def signed_in?(conn) do
        case Map.fetch(conn.assigns, :current_user) do
          {:ok, _user} -> true
          _else -> false
        end
      end
    end
  end
end
