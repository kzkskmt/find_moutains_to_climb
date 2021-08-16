require 'dotenv'
Dotenv.load

require "uri"
require "net/http"
require "json"

key = ENV["GOOGLE_MAP_API_KEY_IP"]
lat = 33.08225
lng = 131.2409444
radius = 500
# 山はestablishmentに含まれて登録されてるっぽい。
# type = establishment
keyword = '九重山'

# キーワードに日本語を含めて検索するためのURI.parse URI.encode
url = URI.parse URI.encode ("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{lng}&radius=#{radius}&type=establishment&keyword=#{keyword}&key=#{key}")

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)
result_json = JSON.parse(response.read_body)

puts true if result_json['status'] == 'ZERO_RESULTS'

# place_id = result_json['results'][0]['place_id']
# place_name = result_json['results'][0]['name']
# puts "#{place_name}: #{place_id}"