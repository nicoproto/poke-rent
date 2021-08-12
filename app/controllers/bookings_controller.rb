class BookingsController < ApplicationController
  include CloudinaryHelper

  before_action :set_booking, only: [ :destroy, :update]
  def new
    @pokemon = Pokemon.find(params[:pokemon_id])
    @booking = Booking.new(start_date: params[:start_date], end_date: params[:end_date])
  end

  def create
    @pokemon = Pokemon.find(params[:pokemon_id])
    @booking = Booking.new(booking_params)
    @booking.pokemon = @pokemon
    @booking.user = current_user
    # raise
    if @booking.save
      # redirect_to booking_path(@booking)

      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: "#{@pokemon.id}_#{@pokemon_name}_#{current_user.id}",
          images: [Cloudinary::Utils.cloudinary_url(@pokemon.photo.key)],
          amount: @pokemon.price_cents,
          currency: 'eur',
          quantity: 1
        }],
        success_url: booking_url(@booking),
        cancel_url: booking_url(@booking)
      )

      @booking.update(checkout_session_id: session.id)
      redirect_to new_booking_payment_path(@booking)
    else
      render :new
    end
  end

  def update
    @booking.send("#{params[:status]}!")
    redirect_to dashboard_path
  end

  def show
    @booking = current_user.bookings.find(params[:id])
  end

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
