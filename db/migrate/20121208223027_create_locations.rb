class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      
      # Gandalf Attributes.
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      
      # Rails Attributes.
      t.timestamps
    end
  end
end
