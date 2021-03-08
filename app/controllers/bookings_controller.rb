class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :destroy]
  def new
    @pokemon = Pokemon.find(params[:pokemon_id])
    @booking = Booking.new
  end

  def create
    @pokemon = Pokemon.find(params[:pokemon_id])
    @booking = Booking.new(booking_params)
    @booking.pokemon = @pokemon
    @booking.user = current_user

    if @booking.save
      redirect_to booking_path(@booking)
    else
      render :new
    end
  end

  def show; end

  def destroy
    @booking.destroy
    # TODO: Redirect to dashboard or booking index when done
    redirect_to root_path
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
