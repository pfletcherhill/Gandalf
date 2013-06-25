class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      
      # Gandalf Attributes.
      t.string :name
      t.text :description
      t.string :room_number
      t.integer :organization_id
      t.integer :location_id
      t.integer :pre_status
      t.integer :post_status

      # Facebook Attributes.
      t.string :fb_id

      # Google Apps Attributes.
      t.string :apps_event_id
      
      # Rails Attributes.
      t.timestamps
    end
    
    create_table :categories_events do |t|
      t.integer :event_id
      t.integer :category_id
    end
  end
end
