class CalendarsController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper # => makes it so it uses the app/helper/application_helper to get user image if they didnt sign up through fb

  def create
    date_from = Date.parse(calendar_params[:start_date])
    date_to = Date.parse(calendar_params[:end_date])

    (date_from..date_to).each do |date|
      calendar = Calendar.where(parking_id: params[:parking_id], day: date)

      if calendar.present?
        calendar.update_all(price: calendar_params[:price], status: calendar_params[:status])
      else
        Calendar.create(
          parking_id: params[:parking_id],
          day: date,
          price: calendar_params[:price],
          status: calendar_params[:status]
        )
      end
    end

    redirect_to host_calendar_path
  end

  def host
    @parkings = current_user.parkings

    params[:start_date] ||= Date.current.to_s
    params[:parking_id] ||= @parkings[0] ? @parkings[0].id : nil

    if params[:q].present?
      params[:start_date] = params[:q][:start_date]
      params[:parking_id] = params[:q][:parking_id]
    end

    @search = Reservation.ransack(params[:q])

    if params[:parking_id]
      @parking = Parking.find(params[:parking_id])
      start_date = Date.parse(params[:start_date])

      first_of_month = (start_date - 1.months).beginning_of_month # => Jun 1
      end_of_month = (start_date + 1.months).end_of_month # => Aug 31

      @events = @parking.reservations.joins(:user)
                      .select('reservations.*, users.fullname, users.image, users.email, users.uid')
                      .where('(start_date BETWEEN ? AND ?) AND status <> ?', first_of_month, end_of_month, 2)
      @events.each{ |e| e.image = avatar_url(e) }
      @days = Calendar.where("parking_id = ? AND day BETWEEN ? AND ?", params[:parking_id], first_of_month, end_of_month)
    else
      @parking = nil
      @events = []
      @days = []
    end
  end

  private
  def calendar_params
    params.require(:calendar).permit([:price, :status, :start_date, :end_date])
  end
end
