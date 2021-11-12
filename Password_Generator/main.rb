# Menu
puts '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
puts "\t\t\t\t  Secure Password Generator\t\t\t\t"
puts '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'

# charcters to be used in password generation 
NUM = ('0'..'9').to_a
UPPER=('A'..'Z').to_a
LOWER=('a'..'z').to_a
SPECIAL_CHAR = ('!'..'?').to_a - NUM
CHAR_FOR_PLAIN = NUM+UPPER+LOWER
CHAR_FOR_COMPLEX = NUM+UPPER+LOWER+SPECIAL_CHAR


def generate_password(level, length)
    if level == 1
        CHAR_FOR_PLAIN.sort_by { rand }.join[0...length]
    elsif level == 2
        CHAR_FOR_COMPLEX.sort_by { rand }.join[0...length]
    else
        "Invalid level"
    end
end

print "Press 1 for simple password\nPress 2 for complex password\n>"
level = gets.to_i

print "Enter length of your password: "
length = gets.to_i

puts "Genreated password: #{generate_password(level, length)}"