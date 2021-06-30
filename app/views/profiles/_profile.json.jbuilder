json.extract! profile, :id, :first_name, :last_name, :user_id, :full_name, :initials

json.url profile_url(profile, format: :json)
json.avatar_small render(partial: 'components/avatar.html.erb', locals: { profile: profile }, formats: [:html])
json.sgid profile.attachable_sgid
json.mention render(partial: 'components/mention.html.erb', locals: { profile: profile }, formats: [:html])
