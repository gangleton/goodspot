class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :hours
      t.text :info
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :type

      t.timestamps
    end
  end
end
