require_relative 'gossip.rb'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb:index ,locals: {gossips: Gossip.all.reverse}
  end

  get '/gossips/new/' do
    erb:new_gossip
  end

  post '/gossips/new/' do
    Gossip.new(params["gossip_author"],params["gossip_content"]).save
    redirect '/'
  end

  get '/gossips/:id/' do
    id = params['id']
    gossip = Gossip.all.select{|x| x['id'] == id}[0]
    erb:show ,locals: {gossip: gossip, id: id}
  end

  get '/gossips/:id/edit/' do
    id = params['id']
    gossip = Gossip.all.select{|x| x['id'] == id}[0]
    erb:edit_gossip ,locals: {gossip: gossip, id: id}
  end

  post '/gossips/:id/edit/' do
    id = params['id']
    gossip = Gossip.all.select{|x| x['id'] == id}[0]
    gossip["author"] = params['gossip_author']
    gossip["content"]= params['gossip_content']
    update_at = Time.now.strftime("%d/%m/%y %k:%M:%S")
    gossip["update_at"] = update_at
    gossips = Gossip.all.map{|x| x['id']==id ? gossip : x}
    Gossip.save_new(gossips)
    redirect '/'
  end

  post '/gossips/:id/' do
    id = params['id']
    gossips = Gossip.all.reject{|x| x['id'] == id};
    Gossip.save_new(gossips)
    redirect '/'
  end

  get '/authors/' do
    list_authors = Gossip.all.map{|x| x['author']}.uniq
    erb:authors, locals: {authors: list_authors}
  end

  get '/author/:name/' do
    name=params['name']
    erb:author, locals: {author: name, gossips: Gossip.all.select{|x| x['author'] == name}}
  end
end
