class CreateTerrorists < ActiveRecord::Migration[7.0]
  def change
    create_table :terrorists do |t|
      t.integer :ent_id
      t.string :name

      t.timestamps
    end
  end
end
