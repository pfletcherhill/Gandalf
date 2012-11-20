class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :bio
      # should have picture field
      t.timestamps
    end
  end
end
