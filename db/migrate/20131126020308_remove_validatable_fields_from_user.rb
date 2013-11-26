class RemoveValidatableFieldsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :email
    remove_column :users, :encrypted_password

    add_column :users, :email, :string
    add_column :users, :encrypted_password, :string
  end
end
