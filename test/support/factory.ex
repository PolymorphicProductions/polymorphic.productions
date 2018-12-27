defmodule PolymorphicProductions.Factory do
  use ExMachina.Ecto, repo: PolymorphicProductions.Repo

  def user_factory do
    %PolymorphicProductions.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "foobarbaz",
      name: "foobar",
      admin: false
    }
  end

  def admin_factory do
    %PolymorphicProductions.Accounts.User{
      email: sequence(:email, &"admin-#{&1}@example.com"),
      password: "foobarbaz",
      name: "foobar",
      admin: true
    }
  end

  def pic_factory do
    %PolymorphicProductions.Social.Pic{
      asset: "http://placehold.jp/150x150.png",
      asset_preview: "http://placehold.jp/150x150.png",
      description: "A street photo of #PDX #OR"
    }
  end

  def comment_factory do
    %PolymorphicProductions.Social.Comment{
      body: "foo bar baz",
      approved: true,
      user: build(:user, password: nil)
    }
  end
end
