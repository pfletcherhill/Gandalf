class CreateEventInstances < ActiveRecord::Migration
  def change
    create_table :event_instances do |t|
      
      # Gandalf Attributes
      t.references :group
      t.references :event
      
      # Google Apps Attributes
      t.string :apps_id
      
      # Rails attributes
      t.timestamps
    end
  end
end
