class CreateLocationAliases < ActiveRecord::Migration
  def change
    create_table :location_aliases do |t|
      
      # Gandalf Attributes.
      t.string :value
      t.references :location
      
      # Rails Attributes.
      t.timestamps
    end
  end
end
