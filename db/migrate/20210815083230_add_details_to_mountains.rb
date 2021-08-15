class AddDetailsToMountains < ActiveRecord::Migration[6.0]
  def change
    add_column :mountains, :twitter_result_count, :integer, default: 0, null: false
  end
end
