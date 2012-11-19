class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :organization_id
      
      t.timestamps
    end
    create_table :categories_events, :id => false do |t|
      t.integer :event_id
      t.integer :category_id
    end
  end
end
