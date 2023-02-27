json.extract! email, :id, :address, :server_id, :project_id, :created_at, :updated_at
json.url email_url(email, format: :json)
