json.extract! message, :id, :channel_id, :profile_id, :content, :created_at, :updated_at
json.url message_url(message, format: :json)
