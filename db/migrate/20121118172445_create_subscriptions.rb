class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      
      # Gandalf Attributes.
      t.integer :subscribeable_id
      t.string :subscribeable_type
      t.integer :user_id
      t.integer :status
      
      # Rails Attributes.
      t.timestamps
    end
  end
end
