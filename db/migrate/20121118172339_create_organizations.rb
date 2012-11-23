class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :bio
      t.string :image
      
      t.timestamps
    end
  end
end
