class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      
      t.string :netid
      t.string :name
      t.string :nickname
      t.string :email
      t.string :college
      t.string :year
      t.string :division
      
      t.boolean :admin
      t.string :bulletin_preference, :default => "daily"

      t.string :fb_id
      t.string :fb_access_token
      t.string :fb_accounts

      # Indeces
      add_index :netid
      add_index :email
      
      t.timestamps
    end
  end
end
