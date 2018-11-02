defmodule PolymorphicProductions.Social.Pix do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExAws.S3

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @extension_whitelist ~w(.jpg .jpeg .png)

  schema "pics" do
    field(:asset, :string)
    field(:description, :string)
    field(:photo, :any, virtual: true)
    timestamps()
  end

  @doc false
  def changeset(pic, attrs) do
    pic
    |> cast(attrs, [:description, :photo])
    |> validate_attachment()
    # |> put_asset()
    # Upload to S3
    |> upload_attachment()
    # Perform any other validations 
    |> validate_required([:description, :asset])
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
        |> Ecto.Changeset.add_error(:asset, "jpg or png only")
    end
  end

  defp validate_attachment(changeset), do: changeset

  # defp put_asset(
  #        %Ecto.Changeset{valid?: true, changes: %{photo: %Plug.Upload{filename: filename}}} =
  #          changeset
  #      ) do
  #   # Set the string for asset based on the known config for S3
  #   changeset |> IO.inspect()

  #   changeset
  #   |> put_change(:asset, "some/config/path" <> filename)
  # end

  # defp put_asset(changeset), do: changeset

  defp upload_attachment(
         %Ecto.Changeset{
           valid?: true,
           changes: %{photo: %Plug.Upload{filename: filename, path: path}}
         } = changeset
       ) do
    import Mogrify

    %{path: new_image} = open(path) |> resize("1100x") |> save()

    new_image
    |> S3.Upload.stream_file()
    |> S3.upload("polymorphic-productions", "/photos/" <> filename, acl: :public_read)
    |> ExAws.request()
    |> IO.inspect()

    changeset
    |> put_change(
      :asset,
      "https://d1sv288qkuffrb.cloudfront.net/polymorphic-productions/photos/" <> filename
    )
  end

  defp upload_attachment(changeset), do: changeset
end
