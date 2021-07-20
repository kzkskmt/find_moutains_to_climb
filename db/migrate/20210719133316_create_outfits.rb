class CreateOutfits < ActiveRecord::Migration[6.0]
  def change
    create_table :outfits do |t|
      t.string :title
      t.text :body
      t.integer :lower_limit_temp
      t.integer :max_elevation
      t.string :image

      t.timestamps
    end
  end
end
