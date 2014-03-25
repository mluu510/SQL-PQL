class UserDetails < ActiveRecord::Migration
  def change
    add_column(:users, :provider, :string, {null: false})
    add_column(:users, :uid, :string, {null: false})
    add_column(:users, :nickname, :string)
    add_column(:users, :name, :string)
    add_column(:users, :email, :string)
    add_column(:users, :avatar_url, :string)

    add_index(:users, :uid, unique: true)
  end
end
