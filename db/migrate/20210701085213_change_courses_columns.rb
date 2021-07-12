class ChangeCoursesColumns < ActiveRecord::Migration[6.0]
  def up
    change_column :courses, :starting_point_lat, :decimal, precision: 10, scale: 7
    change_column :courses, :starting_point_lng, :decimal, precision: 10, scale: 7
    change_column :courses, :ascent_time, :integer
    change_column :courses, :descent_time, :integer
  end
end
