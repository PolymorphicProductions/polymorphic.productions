# defmodule PolymorphicProductionsWeb.EmailTest do
#   use ExUnit.Case
#   use PolymorphicProductionsWeb.ConnCase
#   use Bamboo.Test, shared: true

#   import PolymorphicProductionsWeb.AuthCase
#   alias PolymorphicProductionsWeb.Email

#   setup %{conn: conn} do
#     email = "deirdre@example.com"
#     {:ok, %{conn: conn, email: email, key: gen_key(email)}}
#   end

#   test "sends confirmation request email", %{conn: conn, email: email, key: key} do
#     sent_email = Email.confirm_request(conn, email, key)
#     assert sent_email.subject =~ "Confirm your account"
#     assert sent_email.html_body =~ Routes.confirm_path(conn, :index, key: key)

#     assert_delivered_email(Email.confirm_request(conn, email, key))
#   end

#   test "sends no user found message for password reset attempt" do
#     sent_email = Email.reset_request("gladys@example.com", nil)
#     assert sent_email.text_body =~ "but no user is associated with the email you provided"
#   end

#   test "sends reset password request email", %{email: email, key: key} do
#     sent_email = Email.reset_request(email, key)
#     assert sent_email.subject =~ "Reset your password"
#     assert sent_email.text_body =~ "password at http://www.example.com/password_resets/edit?key="
#     assert_delivered_email(Email.reset_request(email, key))
#   end

#   test "sends receipt confirmation email", %{email: email} do
#     sent_email = Email.confirm_success(email)
#     assert sent_email.text_body =~ "account has been confirmed"
#     assert_delivered_email(sent_email)
#   end

#   test "sends password reset email", %{email: email} do
#     sent_email = Email.reset_success(email)
#     assert sent_email.text_body =~ "password has been reset"
#     assert_delivered_email(Email.reset_success(email))
#   end
# end
