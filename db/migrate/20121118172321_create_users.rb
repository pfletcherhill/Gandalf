class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      
      # Gandalf Attributes.
      t.string :netid
      t.string :name
      t.string :nickname
      t.string :email
      t.string :college
      t.string :year
      t.string :division
      t.boolean :go_admin # To differentiate from the 10,0000 other kinds of admins a user can be.
      t.string :bulletin_preference, :default => "daily"
      
      # Facebook Attributes.
      t.string :fb_id
      t.string :fb_access_token
      t.string :fb_accounts
      
      # Google Apps Attributes.
      t.string :apps_user_id
      
      # Rails Attributes.
      t.timestamps
    end
  end
end
