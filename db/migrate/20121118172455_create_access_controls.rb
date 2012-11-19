class CreateAccessControls < ActiveRecord::Migration
  def change
    create_table :access_controls do |t|
      t.integer :organization_id
      t.integer :user_id
    end
  end
end
