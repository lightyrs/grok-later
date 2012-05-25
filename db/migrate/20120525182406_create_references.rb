class CreateReferences < ActiveRecord::Migration

  def change
    create_table :references do |t|
      t.integer :subject_id, :null => false
      t.integer :link_id, :null => false
    end
  end
end
