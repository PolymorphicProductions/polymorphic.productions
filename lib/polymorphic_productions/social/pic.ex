defmodule PolymorphicProductions.Social.Pic do
  use Ecto.Schema
  import Ecto.Changeset
  alias PolymorphicProductions.Social.{Tagging, Tag}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @extension_whitelist ~w(.jpg)

  @processor Application.fetch_env!(:polymorphic_productions, :asset_processor)
  @uploader Application.fetch_env!(:polymorphic_productions, :asset_uploader)

  schema "pics" do
    field(:asset, :string)
    field(:asset_preview, :string)
    field(:asset_preview_width, :integer)
    field(:asset_preview_height, :integer)

    field(:description, :string)
    field(:photo, :any, virtual: true)
    field(:tag_list, {:array, :string}, virtual: true)
    has_many(:comments, PolymorphicProductions.Social.Comment)
    many_to_many(:tags, Tag, join_through: "pic_tags", on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(pic, attrs) do
    pic
    |> cast(attrs, [:description, :photo])
    |> validate_attachment()
    |> upload_attachment()
    |> validate_required([:description, :asset])
    |> put_tags_list()
    |> parse_tags_assoc()
    |> parse_description()
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
    %{path: scaled_image_path, height: scaled_height, width: scaled_width} =
      @processor.scale_image(image_path)

    @uploader.upload(
      scaled_image_path,
      "/photos/preview/",
      filename
    )

    @uploader.upload(
      image_path,
      "/photos/",
      filename
    )

    changeset
    |> put_change(
      :asset,
      "https://d1sv288qkuffrb.cloudfront.net/polymorphic-productions/photos/" <> filename
    )
    |> put_change(
      :asset_preview,
      "https://d1sv288qkuffrb.cloudfront.net/polymorphic-productions/photos/preview/" <> filename
    )
    |> put_change(
      :asset_preview_height,
      scaled_height
    )
    |> put_change(
      :asset_preview_width,
      scaled_width
    )
  end

  defp upload_attachment(changeset), do: changeset

  defp put_tags_list(
         %Ecto.Changeset{valid?: true, changes: %{description: description}} = changeset
       ) do
    case SocialParser.extract(description, [:hashtags]) do
      %{hashtags: hashs} ->
        tag_list =
          hashs
          |> Enum.map(fn key -> String.replace(key, "#", "") end)

        changeset
        |> put_change(:tag_list, tag_list)

      _ ->
        changeset
    end
  end

  defp put_tags_list(changeset), do: changeset

  defp parse_tags_assoc(
         %Ecto.Changeset{valid?: true, changes: %{tag_list: _tags_list}} = changeset
       ) do
    changeset
    |> Tagging.changeset(PolymorphicProductions.Social.Tag, :tags, :tag_list)
  end

  defp parse_tags_assoc(changeset), do: changeset

  defp parse_description(
         %Ecto.Changeset{valid?: true, changes: %{description: description}} = changeset
       ) do
    parsed_description =
      String.replace(description, ~r/#(\S*)/, "<a href='/snapshots/tags/\\1'>#\\1</a>")

    changeset |> put_change(:description, parsed_description)
  end

  defp parse_description(changeset), do: changeset
end
