class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|

      # Group Attributes.
      t.string :name
      t.string :slug
      t.text :description
      t.integer :organization_id
      t.string :type
      
      # Google Apps Attributes.
      t.string :apps_id
      t.string :apps_email
      t.string :apps_cal_id
      
      # Rails Attributes.
      t.timestamps
    end
    
    create_table :events_groups do |t|
      t.integer :event_id
      t.integer :group_id
    end
  end
end
