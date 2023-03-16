require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'
require 'bcrypt'

get('/') do
    slim(:start)
end

get('/showlogin') do
    slim(:login)
end
  
post('/login') do
    username = params[:username]
    password = params[:password]
  
    db = SQLite3::Database.new('db/salaryCheck.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM users WHERE username = ?",username).first
    pwdigest = result["pwdigest"]
    id = result["id"]
  
    if BCrypt::Password.new(pwdigest) == password
        session[:id] = id
        session[:username] = params[:username]
        redirect('/home')
    else
        "Wrong password"
    end
end

post('/register') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]
  
    if password == password_confirm
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new('db/todo2021.db')
        db.execute('INSERT INTO users (username,pwdigest) VALUES (?,?)', username, password_digest)
        redirect("/")
    else
      "Passwords do not match"
    end
end