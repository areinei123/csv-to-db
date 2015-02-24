require "sinatra"
require 'pg'
require 'pry'
require 'csv'



def db_connection
  begin
    connection = PG.connect(dbname:"ingredients")
    yield(connection)
  ensure
    connection.close
  end
end

db_connection do |conn|
  # might have some logic to check if the table is already created
  # also might want to check if the db is seeded with these ingredients before doing on each start
    CSV.foreach("ingredients.csv") do |row|
      conn.exec_params("INSERT INTO ingredients VALUES ($1)", [row.join('. ')])
    end
end

get "/ingredients" do
  # Retrieve the name of each task from the database
  ingredients = db_connection { |conn| conn.exec("SELECT ingredient FROM ingredients") }
  erb :index, locals: { ingredients: ingredients }
end

# pro move is to have "/ingrdient/:id" and see if you can get a select statement off that
