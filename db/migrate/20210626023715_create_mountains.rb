class CreateMountains < ActiveRecord::Migration[6.0]
  def change
    create_table :mountains do |t|
      t.string :name, null: false
      t.integer :elevation, null: false
      t.integer :prefecture_code, null: false
      t.string :city, null: false
      t.integer :peak_location_lat, null: false
      t.integer :peak_location_lng, null: false
      t.string :image

      t.timestamps
    end
  end
end
