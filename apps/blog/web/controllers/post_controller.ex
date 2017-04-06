defmodule Blog.PostController do
  use Blog.Web, :controller

  alias Blog.Post
  alias Blog.Author

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do

    changeset = Post.changeset(%Post{})

    conn
    |> get_author
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    conn = get_author(conn)

    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to save the post")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do

    post = Repo.one from post in Post,
      where: post.slug == ^id,
      preload: [:author]

    conn
    |> assign(:meta_title, post.meta_title)
    |> assign(:meta_description, post.meta_description)
    |> assign(:meta_author, post.author.name)
    |> assign(:title, post.title)
    |> render("show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    conn = get_author(conn)

    post = Repo.one from post in Post,
      where: post.id == ^id,
      preload: [:author]
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    conn = get_author(conn)

    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post.slug))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  defp get_author(conn) do
    author = get_raw_author(conn)
    conn
    |> assign(:author, author)
  end

  defp get_raw_author(%{assigns: %{current_user: current_user}} = conn) do
    email = case Map.fetch(current_user, :email) do
      {:ok, res} -> res
      _else ->  Map.get(current_user, "email", "")
    end
    case Repo.get_by(Author, email: email) do
      nil -> Repo.one(Author)
      author -> author
    end
  end

  defp get_raw_author(conn) do
    Repo.one(Author)
  end
end
