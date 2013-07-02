class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      
      # Gandalf Attributes.
      t.string :name
      t.string :slug
      t.text :description
      t.string :room_number
      t.integer :pre_status
      t.integer :post_status
      t.integer :organization_id
      t.integer :group_id
      t.integer :location_id
      t.datetime :start_at
      t.datetime :end_at

      # Facebook Attributes.
      t.string :fb_id

      # Google Apps Attributes.
      t.string :apps_id
      
      # Rails Attributes.
      t.timestamps
    end
  end
end
