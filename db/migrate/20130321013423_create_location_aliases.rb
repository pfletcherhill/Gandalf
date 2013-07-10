class CreateLocationAliases < ActiveRecord::Migration
  def change
    create_table :location_aliases do |t|
      
      # Gandalf Attributes.
      t.string :value
      t.integer :location_id
      
      # Rails Attributes.
      t.timestamps
    end
  end
end
