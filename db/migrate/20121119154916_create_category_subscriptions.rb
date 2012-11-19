class CreateCategorySubscriptions < ActiveRecord::Migration
  def change
    create_table :category_subscriptions do |t|
      t.integer :category_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end
