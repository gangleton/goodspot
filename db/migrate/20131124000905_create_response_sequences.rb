class CreateResponseSequences < ActiveRecord::Migration
  def change
    create_table :response_sequences do |t|
      t.integer :phone_number_id
      t.string :outgoings, :array => true, :default => '{}'
      t.string :incomings, :array => true, :default => '{}'

      t.timestamps
    end
  end
end
