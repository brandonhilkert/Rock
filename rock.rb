require 'bundler'
Bundler.require

before do
  @defeat = {rock: :scrissors, paper: :rock, scissors: :paper}
  @throws = @defeat.keys
end

get '/' do  
  erb :index
end

get '/:type' do
  throw = params[:type].to_sym

  if !@throws.include?(throw)
    halt 403, "You must throw rock, paper, or scissors dummy!"
  end

  computer_throw = @throws.sample

  if throw == computer_throw
    @message = "You tied the computer. Try again."
  elsif computer_throw == @defeat[throw]
    @message = "Nicely done, you crushed the computer player!"
  else
    @message = "The computer straight beat you down. Sucks."
  end

  erb :result
end
