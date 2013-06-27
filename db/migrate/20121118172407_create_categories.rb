class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      
      # Gandalf Attributes.
      t.string :name
      t.text :description
      t.string :slug
      t.string :flyer
            
      # Rails Attributes.
      t.timestamps
    end
  end
end
