# Run this command in rails console to run the script:
# load 'lib/scripts/create_stripe_coupon.rb'

# place this file in the lib/scripts/ directory

Stripe.api_key = Rails.configuration.stripe[:secret_key]

puts "Enter the percent discount (e.g., 40):"
percent_off = gets.chomp.to_i

puts "Enter the currency (e.g., usd):"
currency = gets.chomp.downcase

puts "Enter the product IDs: (e.g. 'pid-1', 'pid-2')"
product_ids = gets.chomp

puts "Enter the redeem_by date (YYYY-MM-DD):"
redeem_by_date = gets.chomp

redeem_by_time = Time.parse("#{redeem_by_date} 23:59:59").to_i

coupon_params = {
  percent_off:,
  currency:,
  duration: "once",
  redeem_by: redeem_by_time,
  max_redemptions: nil,
  applies_to: {
    products: [product_ids]
  }
}

coupon = Stripe::Coupon.create(coupon_params)

puts "Coupon ID: #{coupon.id}"
puts "Coupon Redemption Code: #{coupon.code}"
puts "Redeem By: #{Time.at(coupon.redeem_by).utc}"
