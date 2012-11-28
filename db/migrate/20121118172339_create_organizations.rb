class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :bio
      t.string :image
      t.string :color, :default => "220,220,220" # format r,g,b
      
      t.timestamps
    end
  end
end

