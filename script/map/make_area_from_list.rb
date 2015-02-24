#!/home/wataru/.rbenv/shims/ruby
require 'csv'
require 'net/https'
require 'json'


CSV.open("./si.csv", "wb") do |csv|
	hash = Hash.new
	domain = 'maps.googleapis.com'
	http = Net::HTTP.new(domain)
	http.use_ssl = false

	CSV.foreach("./si.list", {:headers => true}) do |row|
		p row
		puts row[0]
		puts row.field("Ja")
		request = "/maps/api/geocode/json?address=" + row.field("Ja") + "&sensor=true_or_false"
		response = http.request_get(request)

		case response
			when Net::HTTPSuccess then
				puts "success"
				data = JSON.parse(response.body)
				hash['lat'] = data['results'][0]['geometry']['location']['lat']
				hash['lng'] = data['results'][0]['geometry']['location']['lng']

			else
				puts "fail"
			end
		csv << [row[0], row[1], hash['lat'].to_s, hash['lng'].to_s]
	end
end