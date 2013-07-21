class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|

      # Group Attributes.
      t.string :name
      t.string :slug
      t.text :description
      t.references :organization
      t.string :type
      
      # Google Apps Attributes.
      t.string :apps_id
      t.string :apps_email
      t.string :apps_cal_id
      
      # Rails Attributes.
      t.timestamps
    end
  end
end
