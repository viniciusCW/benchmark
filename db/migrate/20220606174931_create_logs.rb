class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.string :merch_name
      t.boolean :suspect
      t.string :matches

      t.timestamps
    end
  end
end
