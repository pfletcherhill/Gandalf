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
      
      t.timestamps
    end
  end
end
