class DashboardsController < ApplicationController
  def show
    @my_bookings = current_user.bookings.sort_by { |booking| }
    @my_pokemons_bookings = Booking.select { |booking| booking.pokemon.user == current_user }
  end
end
