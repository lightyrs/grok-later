class CreateCuriosities < ActiveRecord::Migration

  def change
    create_table :curiosities do |t|
      t.integer :subject_id, :null => false
      t.integer :user_id, :null => false
    end
  end
end
