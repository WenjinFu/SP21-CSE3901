require_relative "card.rb"

# Utility class with large helper methods
class Utility
	
	# Produces the deck of 81 cards enumerating over all possible combinations
	def self.new_deck
	
		# Create the empty array of cards
		cards = Array.new

		# Populate with all 81 combos
		Card::VALUE_COUNT.times { |i|
			Card::VALUE_COUNT.times { |j|
				Card::VALUE_COUNT.times { |k|
					Card::VALUE_COUNT.times { |l|
						cards.push Card.new Card::VALUES[i], Card::VALUES[j], Card::VALUES[k], Card::VALUES[l]
					}
				}
			}
		}
		
		# Shuffle and return the new deck
		cards.shuffle!
		cards
	end

	# Draws a nice and fancy greeting message to start the game
	def self.draw_rectangle

		size1="GAME OF SET".size
		length=26+size1

		for i in 0..length
			if i==length
				puts "-"
			else
				print "-"
			end
		end

		for j in 0..7
			for g in 0..length
				if g==0
					print "-"
				elsif g==length
					puts "-"
				else
					print " "
				end
			end
		end

		for m in 0..13
			if m==0
				print "-"
			else
				print " "
			end
		end
		print "GAME OF SET"
		for mm in 0..12
			if mm==0
				print " "
			elsif mm==12
				puts "-"
			else
				print " "
			end
		end

		for j in 0..7
			for gg in 0..length
				if gg==0
					print "-"
				elsif gg==length
					puts "-"
				else
					print " "
				end
			end
		end

		for k in 0..length
			if k==length
				puts "-"
			else
				print "-"
			end
		end

	end
	
	# Draws a nice and fancy farewell message to end the game
	def self.draw_tree
		x='\\'
		puts "            *  Bye!           *        "
		puts "   *               *	"
		puts "         /"+x+"  *             /"+x+"     *"
		puts "        /  "+x+"              /  "+x
		puts "     * /____"+x+"     /"+x+"   * /____"+x
		puts "        /  "+x+"     /  "+x+"     /  "+x+"    "
		puts "       /____"+x+"   /____"+x+"   /____"+x
		puts "         ||       ||       ||"
		puts "-----------------------------------------"
	end

	# Utility method to print a nicely formatted list
	# With "," separating all elements, and ", and" separating the last element.
	def self.print_list(list)
		
		# If there's only one element in the list, just print that directly
		if list.size == 1
			print list[0]
		
			#If there are 2 elements and both elements with an "and" between
        elsif list.size == 2
            print "#{list[0]} and #{list[1]}"
		
		else	
			# Handle with a while loop if number of player is greater than 2
            # The loop will not stop until we've iterated through all but the last of list's data
			
			# Print the first element without a leading space
			print list[0]

			# Iterate through all the middle (non-edge) elements
			i = 1
			while i < list.size - 1 do
				print ", #{list[i]}"
				#After each output completes, it goes to the next location in list
				i += 1
			end
			
			# Print the last element with an and
			print ", and #{list[list.size - 1]}"
        end
	end

	# Prints a basic chart showing the name and score and times for each player
	def self.print_players(players)

		puts "Player Name\t\tScore\t\tTime Since Last Set"
		players.each { |name, player|
			# Print the name with trailing spaces to make its length MAX_NAME_LENGTH
			name_string = "#{name}:#{(" " * (Game::MAX_NAME_LENGTH-name.length))}"
			puts "#{name_string}\t\t#{player.score}\t\t#{player.time_since_last_play.round} s"
		}
		print "\n"

	end

end




		
		
