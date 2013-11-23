class ChangeTypeOnPlace < ActiveRecord::Migration
  def change
    remove_column :places, :type
    add_column :places, :category, :string
  end
end
