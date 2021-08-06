class AddLevelToMountains < ActiveRecord::Migration[6.0]
  def change
    add_column :mountains, :level, :integer
  end
end
