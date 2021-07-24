class AddDetailsToOutfits < ActiveRecord::Migration[6.0]
  def change
    add_column :outfits, :inner, :string
    add_column :outfits, :outer, :string
    add_column :outfits, :outer_bring, :string
    add_column :outfits, :pant, :string
    add_column :outfits, :accessory, :string
  end
end
