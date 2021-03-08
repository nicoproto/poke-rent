class DashboardsController < ApplicationController
  def show
    @my_bookings = current_user.bookings
    @my_pokemons_bookings = Booking.select { |booking| booking.pokemon.user == current_user }
  end
end
