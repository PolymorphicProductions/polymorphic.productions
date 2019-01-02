defmodule PolymorphicProductions.Social.Post do
  use Ecto.Schema
  import Ecto.Changeset

  # 1920x1200
  # 1100x734
  # 550x367

  @extension_whitelist ~w(.jpg)
  @derive {Phoenix.Param, key: :slug}

  @processor Application.fetch_env!(:polymorphic_productions, :asset_processor)
  @uploader Application.fetch_env!(:polymorphic_productions, :asset_uploader)

  schema "posts" do
    field(:body, :string)
    field(:excerpt, :string)
    field(:published_at, :date)
    field(:slug, :string)
    field(:title, :string)
    field(:photo, :any, virtual: true)
    field(:image, :string)
    field(:large_image, :string)
    field(:med_image, :string)
    field(:comment_count, :integer)
    has_many(:comments, PolymorphicProductions.Social.Comment)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :slug, :excerpt, :body, :published_at, :photo])
    |> validate_attachment()
    |> upload_attachment()
    |> put_slug()
    |> validate_required([
      :title,
      :slug,
      :excerpt,
      :body,
      :published_at,
      :image,
      :large_image,
      :med_image
    ])
    |> unique_constraint(:slug, name: :posts_slug_index)
  end

  defp validate_attachment(
         %Ecto.Changeset{
           valid?: true,
           changes: %{photo: %Plug.Upload{filename: filename}}
         } = changeset
       ) do
    file_extension = filename |> Path.extname() |> String.downcase()

    case Enum.member?(@extension_whitelist, file_extension) do
      true ->
        changeset

      _ ->
        changeset
        |> Ecto.Changeset.add_error(:asset, "jpg only")
    end
  end

  defp validate_attachment(changeset), do: changeset

  defp upload_attachment(
         %Ecto.Changeset{
           valid?: true,
           changes: %{photo: %Plug.Upload{filename: filename, path: image_path}}
         } = changeset
       ) do
    # 1920x1200 large
    # 1100x734 med
    # 550x367

    %{path: large_image_path} = @processor.resize_image(image_path, "1920x1200>")

    %{path: med_image_path} = @processor.resize_image(image_path, "1100x734>")

    @uploader.upload(
      large_image_path,
      "/photos/large/",
      filename
    )

    @uploader.upload(
      med_image_path,
      "/photos/med/",
      filename
    )

    @uploader.upload(
      image_path,
      "/photos/",
      filename
    )

    changeset
    |> put_change(
      :image,
      "https://d1sv288qkuffrb.cloudfront.net/polymorphic-productions/photos/" <> filename
    )
    |> put_change(
      :large_image,
      "https://d1sv288qkuffrb.cloudfront.net/polymorphic-productions/photos/large/" <> filename
    )
    |> put_change(
      :med_image,
      "https://d1sv288qkuffrb.cloudfront.net/polymorphic-productions/photos/med/" <> filename
    )
  end

  defp upload_attachment(changeset), do: changeset

  defp put_slug(
         %Ecto.Changeset{
           valid?: true,
           changes: %{title: title}
         } = cs
       ) do
    cs
    |> put_change(:slug, title |> Slug.slugify())
  end

  defp put_slug(changeset), do: changeset
end
