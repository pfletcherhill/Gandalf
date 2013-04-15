class CreateIndices < ActiveRecord::Migration
  def change
    #Indices must be added after tables are created
    change_table :users do |t|
      t.index :netid
      t.index :email
    end
    
    change_table :organizations do |t|
      t.index :slug
    end
    
    change_table :categories do |t|
      t.index :slug
    end
  end
end
