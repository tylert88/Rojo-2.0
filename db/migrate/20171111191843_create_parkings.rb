class CreateParkings < ActiveRecord::Migration[5.1]
  def change
    create_table :parkings do |t|
      t.string :space_type
      t.string :parking_type
      t.integer :accommodate
      t.integer :parking_spot
      t.integer :parking_avail
      t.string :listing_name
      t.text :summary
      t.string :address
      t.boolean :is_lighting
      t.boolean :is_gated
      t.boolean :is_covered
      t.boolean :is_secure
      t.integer :price
      t.boolean :active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
