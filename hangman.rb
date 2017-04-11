require './tools'
require './player_data'



def checkGuess(player_data, letter_given)
    bool = false
  if ((letter?(letter_given)).nil?) || (player_data.incorrect_guesses.include? letter_given) || (player_data.underlined_letters.include? letter_given)
    return [player_data, true]
    #bad input
  end

#GIVEN a letter, collect the positions of where a match was made
matches = player_data.secret_word.each_index.select {|i| player_data.secret_word[i].casecmp(letter_given)==0}

#no matches found. Update turns and "incorrect_guess bank"
 if matches.empty?
  player_data.turns-=1
  player_data.incorrect_guesses << letter_given
 else
# Match found.Update secret_word and underlined_letters
  matches.each do |index| 
    bool = true
    player_data.underlined_letters[index]=player_data.secret_word[index]
    player_data.secret_word[index]=""
  end
 end
 
 return [player_data, bool]

end