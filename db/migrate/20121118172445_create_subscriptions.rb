class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      
      # Gandalf Attributes.
      t.integer :subscribeable_id
      t.string :subscribeable_type
      t.references :group
      t.references :user
      t.integer :access_type, default: 0
      
      # Rails Attributes.
      t.timestamps
    end
  end
end
