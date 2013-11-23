json.array!(@places) do |place|
  json.extract! place, :name, :hours, :info, :address, :latitude, :longitude, :type
  json.url place_url(place, format: :json)
end
