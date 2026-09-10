require 'debug'
require "awesome_print"

class App < Sinatra::Base
  register Sinatra::Reloader

  def db
    return @db if @db

    @db = SQLite3::Database.new(DB_PATH)
    @db.results_as_hash = true

    return @db
  end

  #TODO: Skriv routen hämtar alla frukter i databasen

  get '/fruits' do
    @fruits = db.execute("SELECT * FROM products ORDER BY name ASC")
    ap @fruits
    erb(:"fruits/index")
  end

  get '/fruits/:name' do | name |
    @fruit = db.execute('SELECT * FROM products WHERE name=?',name).first
    ap @fruit
    erb(:"fruits/show")
  end
end


