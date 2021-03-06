class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :destroy, :update]
  def new
    @pokemon = Pokemon.find(params[:pokemon_id])
    @booking = Booking.new(start_date: params[:start_date], end_date: params[:end_date])
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

  def update
    @booking.send("#{params[:status]}!")
    redirect_to dashboard_path
  end

  def show; end

  def destroy
    @booking.destroy
    redirect_to dashboard_path
  end

  private

  def booking_update_params
    params.require(:status)
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
