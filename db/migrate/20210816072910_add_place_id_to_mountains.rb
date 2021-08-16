class AddPlaceIdToMountains < ActiveRecord::Migration[6.0]
  def change
    add_column :mountains, :place_id, :string
  end
end
