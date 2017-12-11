Rails.configuration.stripe = {
  :publishable_key => 'pk_test_3Qx8xqkZerTDdp2tuRGNw85Y',
  :secret_key => 'sk_test_DW2tVctVi5RYbVsBXGRiwps4'
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
