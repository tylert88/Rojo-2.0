class AddFieldsToParking < ActiveRecord::Migration[5.1]
  def change
    add_column :parkings, :latitude, :float
    add_column :parkings, :longitude, :float
  end
end
