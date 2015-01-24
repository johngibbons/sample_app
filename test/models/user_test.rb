require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup 
    @user = User.new(name: "Example User", email: "email@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "User should be valid" do
    assert @user.valid?
  end

  test "User name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "User email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "User name should be 50 characters or less" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "User email should be 255 characters or less" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "Valid email addresses should pass" do
    valid_emails = %w[sample@example.com sample@example.COM sam_Ple@example.org 
      sAm.ple@example.net foo.bar@sample.jp foo+bar@foo.bar.org]

    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "Invalid email addresses should not pass" do
    invalid_emails = %w[sample@example,org sample_at_foo.com user.name@example. 
      foo@bar_baz.com foo@bar+baz.com]

    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should not be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password must be at least 6 characters" do
    @user.password = "a"*5
    @user.password_confirmation = @user.password
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end
