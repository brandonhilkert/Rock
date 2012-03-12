require 'bundler'
Bundler.require

configure do
  enable :sessions
end

before do
  @defeat = {rock: :scissors, paper: :rock, scissors: :paper}
  @throws = @defeat.keys

  session[:you] = 0 unless session[:you]
  session[:computer] = 0 unless session[:computer]
  @message = ""
end

get '/' do  
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
    @message = "You tied the computer. Try again."

  elsif computer_throw == @defeat[throw]
    @message = "Nicely done, you crushed the computer player!"
    session[:you] = session[:you].to_i + 1
  
  elsif throw == @defeat[computer_throw]
    @message = "The computer straight beat you down. Sucks."
    session[:computer] = session[:computer].to_i + 1

  else
    @message = "You know the game. Throw something that matters."
  end

  erb :index
end