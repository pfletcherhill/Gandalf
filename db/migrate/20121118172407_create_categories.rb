class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.string :flyer
      
      t.timestamps

      # Indeces
      add_index :slug
    end
  end
end
