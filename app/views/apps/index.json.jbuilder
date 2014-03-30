json.array!(@apps) do |app|
  json.extract! app, :id, :name, :release_note, :user_id
  json.url app_url(app, format: :json)
end
