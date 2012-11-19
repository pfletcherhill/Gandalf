class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :bio
      
      t.timestamps
    end
  end
end
