require 'sinatra'
#require 'sinatra/reloader'
require './caesar_cipher'
require './tools'
require './player_data'
require './hangman'

$img_num = 0
turns = 0
incorrect_guesses = []
correct_guesses = [1,3,4,5,6,7]
noose = "http://i.imgur.com/qwWiF7s.jpg"
head = "http://i.imgur.com/njfAuiP.jpg"
body = "http://i.imgur.com/wlW9aBw.jpg"
leftArm = "http://i.imgur.com/5yEdTQE.jpg"
rightArm = "http://i.imgur.com/BDdgqFy.jpg"
leftLeg = "http://i.imgur.com/cMvkaW0.jpg"
rightLeg = "http://i.imgur.com/w2YWHqT.jpg"
img_sources = [noose, head, body, leftArm, rightArm, leftLeg, rightLeg]

configure do
	enable :sessions
	set :session_secret, "Namjin"
end

get '/' do
	erb :index
end

get '/hangman' do
	if session["data"].nil?
		secret_word = get_secret_word
		session["data"] = Player_data.new(secret_word)
	end
	
	erb :hangman_index, :locals => {:img=>img_sources[0], :turns => session["data"].turns, :incorrect_guesses => session["data"].incorrect_guesses, :correct_guesses => session["data"].underlined_letters.join(" ")}
end

post '/checkGuess' do
	#takes player_data either changes its fields or not, returns player_data
	player_data = checkGuess(session["data"], params['guess'])
	session["data"] = player_data.first
	good_guess = player_data.last
    #win and lose must be passed an img
    if session["data"].turns <= 0
    	time = Time.new 
	    t = "#{time.month}/#{time.day}/#{time.year}"
        erb :hangman_lose, :locals => {:date => t,  :turns => session["data"].turns, :incorrect_guesses => session["data"].incorrect_guesses, :correct_guesses => session["data"].underlined_letters.join(" "), :secret => session["data"].secret}
	elsif session["data"].secret_word.all? {|e| e == ""}
		erb :hangman_win, :locals => {:img => img_sources[$img_num], :turns => session["data"].turns, :incorrect_guesses => session["data"].incorrect_guesses, :correct_guesses => session["data"].underlined_letters.join(" ")}
	else
		#no win, but may or may not be a good guess
		if !good_guess
			$img_num +=1
		end
		
		erb :hangman_index, :locals => {:img => img_sources[$img_num], :turns => session["data"].turns, :incorrect_guesses => session["data"].incorrect_guesses, :correct_guesses => session["data"].underlined_letters.join(" ")}
	end
    
end

#called whenever 'new game' is clicked
get '/getNewSecret' do
	$img_num = 0
	session["data"] = Player_data.new(get_secret_word)
	erb :hangman_index, :locals => {:img => img_sources[$img_num], :turns => session["data"].turns, :incorrect_guesses => session["data"].incorrect_guesses, :correct_guesses => session["data"].underlined_letters.join(" ")}
end

#CAESAR APP
get '/caesarCipher' do
	color = change_color
	erb :cipher_index, :locals => {:encryptedMessage => "", :color=>color}
end

post '/runMethod' do
	color = change_color
    encryption = caesar_cipher(params['message'],params['shiftFactor'].to_i)
	erb :cipher_index, :locals => {:encryptedMessage => encryption, :color => color}
end

def change_color
	"##{"%06x" % (rand * 0xffffff)}"
end