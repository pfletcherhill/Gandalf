class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      
      # Gandalf Attributes.
      t.integer :subscribeable_id
      t.string :subscribeable_type
      t.integer :group_id
      t.integer :user_id
      t.integer :access_type
      
      # Rails Attributes.
      t.timestamps
    end
  end
end
