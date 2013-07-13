class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      
      # Gandalf Attributes.
      t.string :name
      t.string :slug
      t.text :description
      t.string :room_number
      t.references :organization
      t.references :location
      t.datetime :start_at
      t.datetime :end_at

      # Facebook Attributes.
      t.string :fb_id
      
      # Rails Attributes.
      t.timestamps
    end
  end
end
