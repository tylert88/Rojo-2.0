class ReservationMailer < ApplicationMailer
  def send_email_to_guest(guest, parking)
    @recipient = guest
    @parking = parking
    mail(to: @recipient.email, subject: "Enjoy the Spot! 😎 ")
  end
end
