json.array!(@regions) do |region|
  json.extract! region, :name, :subdomain, :background_url
  json.url region_url(region, format: :json)
end
