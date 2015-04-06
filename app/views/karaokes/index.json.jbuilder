json.array!(@karaokes) do |karaoke|
  json.extract! karaoke, :id, :actor, :introduction, :picture, :video1, :video2, :ballot1
  json.url karaoke_url(karaoke, format: :json)
end
