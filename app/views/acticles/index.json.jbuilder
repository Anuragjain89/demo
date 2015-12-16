json.array!(@acticles) do |acticle|
  json.extract! acticle, :id, :name, :description
  json.url acticle_url(acticle, format: :json)
end
