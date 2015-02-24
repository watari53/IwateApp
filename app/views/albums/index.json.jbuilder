json.array!(@albums) do |album|
  json.extract! album, :id, :title, :description, :address, :latitude, :longitude, :date
  json.url album_url(album, format: :json)
end
