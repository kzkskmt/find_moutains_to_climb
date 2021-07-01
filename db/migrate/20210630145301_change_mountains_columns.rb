class ChangeMountainsColumns < ActiveRecord::Migration[6.0]
  def up
    change_column :mountains, :peak_location_lat, :decimal, precision: 10, scale: 7
    change_column :mountains, :peak_location_lng, :decimal, precision: 10, scale: 7
  end
end
