class RemoveTotalPriceFromBookings < ActiveRecord::Migration[6.0]
  def change
    remove_column :bookings, :total_price
  end
end
