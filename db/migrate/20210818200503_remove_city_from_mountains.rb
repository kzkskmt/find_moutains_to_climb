class RemoveCityFromMountains < ActiveRecord::Migration[6.0]
  def change
    remove_column :mountains, :city, :string
  end
end
