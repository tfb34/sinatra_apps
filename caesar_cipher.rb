def caesar_cipher(str,shiftFactor)
  str=str.split("")
  str.each_with_index do |char,i|
  	if is_letter(char)
  		str[i]=shift(char, shiftFactor)
  	end
  end
  str.join
end

def is_letter(input)
  return false if input.length >1
  input[/[a-zA-Z]+/] == input
end

def shift(char, shiftFactor)
   letters = ('a'..'z').to_a
   if char == char.upcase; upcase = true else upcase = false end

   i = (char.downcase.sum - 97 + shiftFactor) % letters.length
   
   if upcase; letters[i].upcase else letters[i] end
end
