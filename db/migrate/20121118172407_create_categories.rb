class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :bio
      
      t.timestamps
    end
    create_table :categories_users do |t|
      t.integer :category_id
      t.integer :user_id
    end
  end
end
