json.survivors do
  json.partial! 'api/v1/survivors/show', collection: @survivors, as: :survivor
end
