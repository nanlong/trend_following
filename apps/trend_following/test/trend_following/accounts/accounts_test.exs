defmodule TrendFollowing.AccountsTest do
  use TrendFollowing.DataCase

  alias TrendFollowing.Accounts

  describe "users" do
    alias TrendFollowing.Accounts.User

    @valid_attrs %{email: "test@trendfollowing.cc",  password: "123456", password_confirmation: "123456"}
    @invalid_attrs %{email: nil, password: nil, password_confirmation: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    @tag accounts_user: true
    test "get_user!/1" do
      user = user_fixture()
      assert Accounts.get_user!(user.email).id == user.id
    end

    @tag accounts_user: true
    test "create_user/1 when data is valid" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "test@trendfollowing.cc"
      assert user.nickname == "test"
    end

    @tag accounts_user: true
    test "create_user/1 when data is invalid" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    @tag accounts_user: true
    test "update_user/3 for profile when data is valid" do
      user = user_fixture()
      attrs = %{nickname: "trendfollowing"}
      assert {:ok, user} = Accounts.update_user_profile(user, attrs)
      assert %User{} = user
      assert user.nickname == "trendfollowing"
    end

    @tag accounts_user: true
    test "update_user/3 for profile when data is invalid" do
      user = user_fixture()
      attrs = %{nickname: nil}
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_profile(user, attrs)
    end

    @tag accounts_user: true
    test "update_user/3 for password when data is valid" do
      user = user_fixture()
      attrs = %{old_password: "123456", password: "654321", password_confirmation: "654321"}
      assert {:ok, user} = Accounts.update_user_password(user, attrs)
      assert %User{} = user
      assert Comeonin.Argon2.checkpw("654321", user.password_hash)
    end

    @tag accounts_user: true
    test "update_user/3 for password when data is invalid" do
      user = user_fixture()
      attrs = %{old_password: nil, password: nil, password_confirmation: nil}
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_password(user, attrs)
    end

    @tag accounts_user: true
    test "update_user/3 for password_reset when data is valid" do
      user = user_fixture()
      attrs = %{password: "654321", password_confirmation: "654321"}
      assert {:ok, user} = Accounts.update_user_password_reset(user, attrs)
      assert %User{} = user
    end

    @tag accounts_user: true
    test "update_user/3 for password_reset when data is invalid" do
      user = user_fixture()
      attrs = %{password: nil, password_confirmation: nil}
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_password_reset(user, attrs)
    end

    @tag accounts_user: true
    test "change_user/1" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    @tag accounts_user: true
    test "change_user_profile/1" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_profile(user)
    end

    @tag accounts_user: true
    test "change_user_password/1" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_password(user)
    end

    @tag accounts_user: true
    test "change_user_password_reset/1" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_password_reset(user)
    end
  end

  describe "session" do
    alias TrendFollowing.Accounts.Session

    @tag accounts_session: true
    test "change_session/1" do
      assert %Ecto.Changeset{} = Accounts.change_session(%Session{})
    end

    @tag accounts_session: true
    test "create_session/1 when data is valid" do
      user = user_fixture()
      attrs = %{email: "test@trendfollowing.cc", password: "123456"}
      assert {:ok, session_user} = Accounts.create_session(attrs)
      assert user.id == session_user.id
    end

    @tag accounts_session: true
    test "create_session/1 when data is invalid" do
      attrs = %{email: "test@trendfollowing.cc", password: "errorpassword"}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_session(attrs)
    end
  end
end
