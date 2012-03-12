require 'bundler'
Bundler.require

configure do
  enable :sessions
end

before do
  @defeat = {rock: :scissors, paper: :rock, scissors: :paper}
  @throws = @defeat.keys

  reset_score if session[:you].nil? || session[:computer].nil?
end

def reset_score
  session[:you] = 0
  session[:computer] = 0
end

def check_for_end
  if session[:you].to_i == 10 || session[:computer].to_i == 10
    redirect "/"
  end
end

get '/' do  
  if session[:you].to_i == 10
    reset_score
    @message = {success: "You're the man. Go again!"}

  elsif session[:computer].to_i == 10
    reset_score
    @message = {error: "Boo hoo...Get 'em next time."}
  end

  erb :index
end

get '/reset' do
  session.clear
  redirect '/'
end

get '/:type' do
  throw = params[:type].to_sym

  computer_throw = @throws.sample

  if throw == computer_throw
    @message = {info: "You tied the computer. Try again."}

  elsif computer_throw == @defeat[throw]
    session[:you] = session[:you].to_i + 1
    check_for_end
    @message = {success: "Nicely done, you crushed the computer player!"}
  
  elsif throw == @defeat[computer_throw]
    session[:computer] = session[:computer].to_i + 1
    check_for_end
    @message = {error: "The computer straight beat you down. Sucks."}

  else
    @message = {error: "You know the game. Throw something that matters."}
  end

  erb :index
end