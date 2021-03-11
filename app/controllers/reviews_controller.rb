class ReviewsController < ApplicationController
  before_action :set_booking, only: [:new, :create]
  before_action :set_review, only: [:edit, :update]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.booking = @booking

    if @review.save
      redirect_to @booking.pokemon
    else
      render :new
    end
  end

  def edit; end

  def update
    @review.update(review_params)
    if @review.save
      redirect_to @review.booking.pokemon
    else
      render :edit
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end
end
