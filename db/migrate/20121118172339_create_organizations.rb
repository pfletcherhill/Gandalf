class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :bio
      t.string :slug
      t.string :image
      t.string :color, :default => "150,150,150" # format r,g,b

      t.timestamps
    end
  end
end

