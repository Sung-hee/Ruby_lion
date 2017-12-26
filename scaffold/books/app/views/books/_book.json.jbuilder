json.extract! book, :id, :isbn, :title, :price, :publish, :published, :cd, :created_at, :updated_at
json.url book_url(book, format: :json)
