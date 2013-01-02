class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.string :flyer
      
      t.timestamps
    end
  end
end
