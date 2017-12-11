class ReservationsController < ApplicationController
before_action :authenticate_user!
before_action :set_reservation, only: [:approve, :decline]

def create
  parking = Parking.find(params[:parking_id])

  if current_user == parking.user
    flash[:alert] = "You cannot book your own parking space!"
  elsif current_user.stripe_id.blank?
    flash[:alert] = "Please update your payment method."
    return redirect_to payment_method_path
  else
    start_date = Date.parse(reservation_params[:start_date])
    end_date = Date.parse(reservation_params[:end_date])
    days = (end_date - start_date).to_i + 1

    special_dates = parking.calendars.where(
        "status = ? AND day BETWEEN ? AND ? AND price <> ?",
        0, start_date, end_date, parking.price
      )

  @reservation = current_user.reservations.build(reservation_params)
  @reservation.parking = parking
  @reservation.price = parking.price
  # @reservation.total = parking.price * days
  # @reservation.save

  @reservation.total = parking.price * (days - special_dates.count)
      special_dates.each do |date|
          @reservation.total += date.price
      end
  
  if @reservation.Waiting!
    if parking.Request?
      flash[:notice]= "Request sent Successfully!"
    else
      charge(parking, @reservation)
    end
  else
    flash[:alert] = "Cannot make a reservation.."
  end

  end
  redirect_to parking
end

def your_spots
  @spots = current_user.reservations.order(start_date: :asc)
end

def your_reservations
  @parkings = current_user.parkings
end

def approve
  charge(@reservation.parking, @reservation)
  redirect_to your_reservations_path
end

def decline
  @reservation.Declined!
  redirect_to your_reservations_path
end

private

def send_sms(parking, reservation)
      @client = Twilio::REST::Client.new
      @client.messages.create(
        from: '7192498022',
        to: parking.user.phone_number,
        body: "#{reservation.user.fullname} booked your '#{parking.listing_name}'"
      )
    end


def charge(parking, reservation)
  if !reservation.user.stripe_id.blank?
    customer = Stripe::Customer.retrieve(reservation.user.stripe_id)
    charge = Stripe::Charge.create(
      :customer => customer.id,
      :amount => reservation.total * 100,
      :description => parking.listing_name,
      :currency => "usd",
      :destination => {
        :amount => reservation.total * 80, # 80% of the total amount goes to the Host
        :account => parking.user.merchant_id # Host's Stripe customer ID
      }
    )


    if charge
          reservation.Approved!
          ReservationMailer.send_email_to_guest(reservation.user, parking).deliver_later if reservation.user.setting.enable_email
          send_sms(parking, reservation) if parking.user.setting.enable_sms
          flash[:notice] = "Reservation created successfully!"
        else
          reservation.Declined!
          flash[:alert] = "Cannot charge with this payment method!"
        end
      end
    rescue Stripe::CardError => e
      reservation.declined!
      flash[:alert] = e.message
    end

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date)
    end
end


#       reservation.Declined!
#       flash[:notice] = "Cannot charge with this payment method.."
#     end
#   end
#   rescue Exception => e
#     reservation.Declined!
#     flash[:notice] = e.message
# end
#
#   def set_reservation
#     @reservation = Reservation.find(params[:id])
#   end
#
#   def reservation_params
#       params.require(:reservation).permit(:start_date, :end_date)
#     end
# end
