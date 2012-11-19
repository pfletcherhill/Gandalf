class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :subscribeable_id
      t.integer :user_id
      t.string :subscribeable_type
      
      t.timestamps
    end
  end
end
