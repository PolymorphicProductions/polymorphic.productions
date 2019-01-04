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
    # field(:published_at_local, :string)
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
      # :published_at_local
    ])
    # |> validate_format(
    #   :published_at_local,
    #   ~r/^\d{1,2}\/\d{1,2}\/\d{4}$/
    # )
    |> validate_length(:excerpt, max: 255)
    # |> validate_published_at()
    # |> put_published_at()
    |> put_slug()
    |> put_parsed_body()
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

  # defp validate_published_at(
  #        %Ecto.Changeset{
  #          valid?: true,
  #          changes: %{published_at_local: published_at_local}
  #        } = cs
  #      ) do
  #   case Timex.parse(published_at_local, "%m/%d/%Y", :strftime) do
  #     {:ok, _} ->
  #       cs

  #     {:error, _} ->
  #       cs
  #       |> add_error(:published_at_local, "not a valid date")
  #   end
  # end

  # defp validate_published_at(cs), do: cs

  # defp put_published_at(
  #        %Ecto.Changeset{
  #          valid?: true,
  #          changes: %{published_at_local: published_at_local}
  #        } = cs
  #      ) do
  #   case Timex.parse(published_at_local, "%m/%d/%Y", :strftime) do
  #     {:ok, date} ->
  #       cs
  #       |> put_change(:published_at, date |> published_at)

  #     {:error, _} ->
  #       cs
  #       |> add_error(:published_at_local, "not a valid date")
  #   end

  #   case

  #   published_at_local
  #   |> Timex.parse!("%m/%d/%Y", :strftime)
  #   |> Timex.to_date()

  #   cs
  #   |> put_change(:published_at, published_at)
  # end

  # defp put_published_at(cs), do: cs

  defp put_slug(cs), do: cs

  defp put_parsed_body(%Ecto.Changeset{valid?: true, changes: %{body: body}} = cs) do
    case Earmark.as_html(body) do
      {:ok, html_doc, _} ->
        put_change(cs, :body_parsed, html_doc)

      {:error, _, error_messages} ->
        add_error(cs, :body, error_messages)
    end
  end

  defp put_parsed_body(cs), do: cs
end
