class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.integer :ascent_time, null: false
      t.integer :descent_time, null: false
      t.integer :level, null: false
      t.decimal :starting_point_lat, precision: 10, scale: 7, null: false
      t.decimal :starting_point_lng, precision: 10, scale: 7, null: false
      t.references :mountain, null: false, foreign_key: true

      t.timestamps
    end
  end
end
