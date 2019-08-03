json.extract! channel, :id, :url, :name, :status, :created_at, :updated_at
json.url channel_url(channel, format: :json)
