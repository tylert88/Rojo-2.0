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
    @parking = current_user.parkings.build(parking_params)
    if @parking.save
      redirect_to listing_parking_path(@parking), notice: "Saved..."
    else
      flash[:aleart] = "Something went wrong..."
      render :new
  end
end

  def show
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
    if @parking.update(parking_params)
       flash[:notice] = "Saved..."
     else
       flash[:aleart] = "Something went wrong..."
    end
     redirect_back(fallback_location: request.referer)
  end

  private
    def set_parking
      @parking = Parking.find(params[:id])
    end

    def is_authorised
      redirect_to root_path, aleart: "You do not have permission" unless current_user.id == @parking.user_id
    end

  def parking_params
    params.require(:parking).permit(:space_type, :parking_type, :accommodate, :parking_spot, :parking_avail, :listing_name, :summary, :address, :is_lighting, :is_gated, :is_covered, :is_secure, :price, :active)
  end
end
