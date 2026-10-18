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

  get '/categories' do
    @categories = db.execute('SELECT * FROM categories')
    ap @categories
    erb(:"categories/index")
  end

  get '/categories/:category' do | name |
    @categories = db.execute('SELECT * FROM categories WHERE name=?', name)
    @category = db.execute('SELECT * FROM categories 
		WHERE name=?', name).first
    @fruits = db.execute("SELECT * FROM products WHERE category_id=? ORDER BY name ASC", @category['id'])
    ap @categories
    ap @category
    ap @fruits
    erb(:"categories/show")
  end
  
  get '/fruits/new' do
    @categories = db.execute('SELECT * FROM categories')
    erb(:"fruits/new")
  end
  
  get '/fruits/:name' do | name |
    @fruit = db.execute("SELECT * FROM products WHERE name=?", name).first
    @category = db.execute(
    'SELECT * FROM categories WHERE id=?', @fruit['category_id']).first
    ap @category
    ap @fruit
    erb(:"fruits/show")
  end
  
  get '/fruits/:id/edit' do | id |
    @fruit = db.execute("SELECT * FROM products WHERE id=?", id).first
    @category = db.execute('SELECT * FROM categories 
		WHERE id=?', id).first
    ap @fruit
    ap @category
    erb(:"fruits/edit")
  end
  
  post '/fruits' do
    ap params
    f_name = params[:"fruit_name"]
    f_tastiness = params[:"fruit_tastiness"]
    f_description = params[:"fruit_description"]
    f_category = params[:"fruit_category"]
    db.execute("INSERT INTO products (name, tastiness, description, category_id) VALUES (?,?,?,?);", [f_name, f_tastiness, f_description, f_category])
    redirect("/fruits")
  end
  
  post '/fruits/:id/delete' do | id |
    db.execute("DELETE FROM products WHERE id=?", id)
    redirect("/fruits")
  end
  
  post '/fruits/:id/update' do | id |
    ap params
    f_name = params[:"fruit_name"]
    f_tastiness = params[:"fruit_tastiness"]
    f_description = params[:"fruit_description"]
    f_category = params[:"fruit_category"]
    db.execute("UPDATE products SET name=?, tastiness=?, description=? , category_id=? WHERE id=?", [f_name, f_tastiness, f_description, category_id, id])
    redirect("/fruits")
  end 

end


