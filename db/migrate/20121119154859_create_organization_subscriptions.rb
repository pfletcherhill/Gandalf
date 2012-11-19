class CreateOrganizationSubscriptions < ActiveRecord::Migration
  def change
    create_table :organization_subscriptions do |t|
      t.integer :organization_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end
