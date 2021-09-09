class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.date :climbed_on, null: false
      t.integer :course_time, null: false
      t.integer :review, null: false
      t.integer :level, null: false
      t.integer :physical_strength, null: false
      t.references :user, null: false, foreign_key: true
      t.references :mountain, null: false, foreign_key: true

      t.timestamps
    end
  end
end
