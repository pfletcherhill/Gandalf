class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|

      # Group Attributes.
      t.string :name
      t.string :slug
      t.text :description
      t.integer :groupable_id
      t.string :groupable_type
      
      # Google Apps Attributes.
      t.string :apps_id
      t.string :apps_email
      t.string :apps_cal_id
      
      # Rails Attributes.
      t.timestamps
    end
  end
end
