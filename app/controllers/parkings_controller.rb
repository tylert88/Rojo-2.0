class ParkingsController < ApplicationController
  before_action :set_parking, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorised, only: [:listing, :pricing, :discription, :photo_upload, :amenities, :location]

  def index
    @parkings = current_user.parkings
  end
  
  def new
    @parking = current_user.parkings.build
  end

  def create
    if !current_user.is_active_host
      return redirect_to payout_method_path, alert: "Please Connect to Stripe Express first."
    end

      @parking = current_user.parkings.build(parking_params)
    if @parking.save!
      redirect_to listing_parking_path(@parking), notice: "Saved..."
    else
      flash[:alert] = "Something went wrong..."
      render :new
    end
  end

  def show
    @photos = @parking.photos
    @guest_reviews = @parking.guest_reviews
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
    @photos = @parking.photos
  end

  def amenities
  end

  def location
  end

  def update

    new_params = parking_params
    new_params = parking_params.merge(active: true) if is_parking_ready

    if @parking.update(new_params)
       flash[:notice] = "Saved..."
     else
       flash[:alert] = "Something went wrong..."
    end
     redirect_back(fallback_location: request.referer)
  end


  def preload
    # ----Reservations----

    today = Date.today
    reservations = @parking.reservations.where("(start_date >= ? OR end_date >= ?) AND status = ?", today, today, 1)

    render json: reservations
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date, @parking)
    }

    render json: output
  end


  private

    def is_conflict(start_date, end_date, parking)
      check = parking.reservations.where("(? < start_date AND end_date < ?) AND status = ?", start_date, end_date, 1)
      check.size > 0? true : false
    end

    def set_parking
      @parking = Parking.find(params[:id])
    end

    def is_authorised
      redirect_to root_path, alert: "You do not have permission" unless current_user.id == @parking.user_id
    end

    def is_parking_ready
        !@parking.active && !@parking.price.blank? && !@parking.listing_name.blank? && !@parking.photos.blank? && !@parking.address.blank?
    end

    def parking_params
      params.require(:parking).permit(:space_type, :parking_type, :accommodate, :parking_spot, :parking_avail, :listing_name, :summary, :address, :is_lighting, :is_gated, :is_covered, :is_secure, :price, :active, :instant)
    end
end
