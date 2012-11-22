class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :organization_id
      t.datetime :start_at
      t.datetime :end_at
      t.string :location
      t.string :address # to google map with
      t.text :description
      
      t.timestamps
    end
    create_table :categories_events do |t|
      t.integer :event_id
      t.integer :category_id
    end
  end
end
