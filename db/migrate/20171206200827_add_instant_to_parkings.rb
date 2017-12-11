class AddInstantToParkings < ActiveRecord::Migration[5.1]
  def change
    add_column :parkings, :instant, :integer, default: 1
  end
end
