json.extract! config_item, :id, :name, :value, :comment, :created_at, :updated_at
json.url config_item_url(config_item, format: :json)
