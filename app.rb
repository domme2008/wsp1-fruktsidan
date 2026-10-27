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
  
  get '/categories' do
    @categories = db.execute("SELECT * FROM categories")
    ap @categories
    erb(:"categories/index")
  end
  
  get '/fruits' do
    @fruits = db.execute("SELECT * FROM products ORDER BY name ASC")
    ap @fruits
    erb(:"fruits/index")
  end
  
  get '/categories/new' do
    @categories = db.execute("SELECT * FROM categories")
    erb(:"categories/new")
  end
  
  get '/fruits/new' do
    @categories = db.execute("SELECT * FROM categories")
    erb(:"fruits/new")
  end
  
  get '/categories/:id/edit' do | id |
    @category = db.execute("SELECT * FROM categories 
    WHERE id=?", id).first
    ap @category
    erb(:"categories/edit")
  end

  get '/fruits/:id/edit' do | id |
    @fruit = db.execute("SELECT * FROM products WHERE id=?", id).first
    @categories = db.execute("SELECT * FROM categories")
    ap @fruit
    ap @category
    erb(:"fruits/edit")
  end
  
  get '/categories/:id' do | id |
    @category = db.execute("SELECT * FROM categories 
		WHERE id=?", id).first
    @fruits = db.execute("SELECT * FROM products WHERE category_id=? ORDER BY name ASC", @category['id'])
    ap @categories
    ap @category
    ap @fruits
    erb(:"categories/show")
  end
  
  get '/fruits/:id' do | id |
    @fruit = db.execute("SELECT * FROM products WHERE id=?", id).first
    @category = db.execute(
      'SELECT * FROM categories WHERE id=?', @fruit['category_id']).first
    ap @category
    ap @fruit
    erb(:"fruits/show")
  end
  
  post '/categories' do
    ap params
    c_name = params[:"category_name"]
    c_description = params[:"category_description"]
    db.execute("INSERT INTO categories (name, description) VALUES (?,?)", [c_name, c_description])
    redirect(:"categories")
  end

  post '/categories/:id/delete' do | id |
    db.execute("DELETE FROM categories WHERE id=?", id)
    redirect("/categories")
  end

  post '/categories/:id/update' do | id |
    ap params
    c_name = params[:"category_name"]
    c_description = params[:"category_description"]  
    db.execute("UPDATE categories SET name=?, description=? WHERE id=?", [c_name, c_description, id])
    redirect(:"categories")
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
    db.execute("UPDATE products SET name=?, tastiness=?, description=?, category_id=? WHERE id=?", [f_name, f_tastiness, f_description, f_category, id])
    redirect("/fruits")
  end 

end


