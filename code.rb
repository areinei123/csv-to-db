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
    CSV.foreach("ingredients.csv") do |row|
      conn.exec_params("INSERT INTO ingredients VALUES ($1)", [row.join('. ')])
      # binding.pry
    end
end

get "/ingredients" do
  # Retrieve the name of each task from the database
  ingredients = db_connection { |conn| conn.exec("SELECT ingredient FROM ingredients") }
  erb :index, locals: { ingredients: ingredients }
end
