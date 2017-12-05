class PhotosController < ApplicationController

  def create
    @parking = Parking.find(params[:parking_id])

    if params[:images]
      params[:images].each do |img|
        @parking.photos.create(image: img)
      end

      @photos = @parking.photos
      redirect_back(fallback_location: request.referer, notice: "Saved...")
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @parking = @photo.parking

    @photo.destroy
    @photos = Photo.where(parking_id: @parking.id)

    respond_to :js
  end
end
