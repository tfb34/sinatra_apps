def letter? (lookAhead)
	lookAhead=~ /[[:alpha:]]/
  end


#strip /r/n and select words that have length 5..12
def parse_dictionary(x=5,y=12)
	dictionary=[]
	File.foreach('dictionary.txt') do |line|
	  if line.chomp.length.between?(x,y)
	    dictionary << line.chomp
      end
    end
    return dictionary

end

def get_secret_word
	dictionary=parse_dictionary
	random_value=rand(0...dictionary.length)
    secret_word= dictionary[random_value].split("")
end



def get_player_data
 while(true)
	choice=gets.chomp
	#NEW GAME
	if choice=="1"
        player_data=Player_data.new(get_secret_word)
        return player_data
    #LOAD GAME
	elsif choice=="2"
		player_data=load_game
		if player_data.nil?
		   puts "Enter 1 to start new game or 2 to load game:"
		else
			puts player_data#to show players history
		    return player_data
	    end
	end
 end

end