class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description # should be self explanatory though...
      
      t.timestamps
    end
  end
end
