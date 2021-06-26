class CreateEquipment < ActiveRecord::Migration[6.0]
  def change
    create_table :equipment do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :ware_name, null: false
      t.text :ware_description, null: false
      t.string :gear_name, null: false
      t.text :gear_description, null: false
      t.integer :lower_limit_temp, null: false
      t.integer :max_elevation, null: false
      t.string :image

      t.timestamps
    end
  end
end
