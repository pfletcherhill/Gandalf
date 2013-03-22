class CreateLocationAliases < ActiveRecord::Migration
  def change
    create_table :location_aliases do |t|
      t.string :value
      t.integer :location_id
      t.timestamps
    end
  end
end
