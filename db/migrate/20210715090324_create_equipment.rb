class CreateEquipment < ActiveRecord::Migration[6.0]
  def change
    create_table :equipment do |t|
      t.string :title, null: false
      t.text :body
      t.integer :lower_limit_temp, null: false
      t.integer :max_elevation, null: false
      t.string :image

      t.timestamps
    end
  end
end
