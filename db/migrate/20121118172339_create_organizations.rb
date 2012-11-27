class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :bio
      t.string :image
      t.string :color # format r,g,b
      
      t.timestamps
    end
  end
end

