class CreateAccessControls < ActiveRecord::Migration
  def change
    create_table :access_controls do |t|
      t.integer :organization_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end
