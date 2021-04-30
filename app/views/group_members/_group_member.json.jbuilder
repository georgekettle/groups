json.extract! group_member, :id, :profile_id, :group_id, :role, :created_at, :updated_at
json.url group_member_url(group_member, format: :json)
