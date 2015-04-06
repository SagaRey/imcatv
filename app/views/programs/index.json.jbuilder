json.array!(@programs) do |program|
  json.extract! program, :id, :datatime, :content
  json.url program_url(program, format: :json)
end
