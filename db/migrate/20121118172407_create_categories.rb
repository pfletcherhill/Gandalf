class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      
      # Gandalf Attributes.
      t.string :name
      t.text :description
      t.string :slug
      t.string :flyer
      
      # Google Apps Attributes.
      t.string :apps_group_id
      t.string :apps_group_email
      t.string :apps_cal_id
            
      # Rails Attributes.
      t.timestamps
    end
  end
end
