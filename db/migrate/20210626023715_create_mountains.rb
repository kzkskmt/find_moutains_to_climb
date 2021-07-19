class CreateMountains < ActiveRecord::Migration[6.0]
  def change
    create_table :mountains do |t|
      t.string :name, null: false
      t.string :name_en, null: false
      t.integer :elevation, null: false
      t.integer :prefecture_code, null: false
      t.string :city
      t.decimal :peak_location_lat, precision: 10, scale: 7, null: false
      t.decimal :peak_location_lng, precision: 10, scale: 7, null: false
      t.string :image

      t.timestamps
    end
  end
end
