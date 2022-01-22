require_relative 'utility.rb'
require_relative 'card.rb'

# Set of Game start with game tatus overview on table.
# Typically, the table contains deck of cards on table, deck/Array of remaining cards and deck/array of discarded cards, each player's score, game time elapsed
class Table 

	attr_accessor :cards_on_table
	attr_accessor :cards_remaining
	attr_accessor :cards_discarded

	# The default number of cards on the table
	DEFAULT_TABLE_SIZE = 12

	def initialize
		# Initialize the cards on table and cards discarded to empty arrays
		@cards_discarded = Array.new
		@cards_on_table = Array.new
		
		# Use the Deck Utility class to generate all 81 cards for the cards remaining
		@cards_remaining = Utility.new_deck
		
		@cards_num_table = 0

		@possible_set = Array.new 3

		DEFAULT_TABLE_SIZE.times {
			@cards_on_table.push @cards_remaining.pop
		}

	end

	# Moves 3 cards from the cards_remaining to the cards_on_table if there are still enough cards remaining
    def add_3_cards

		Card::VALUE_COUNT.times {
            @cards_on_table.push @cards_remaining.shift if @cards_remaining.size > 0
        }

    end
		
		
	# Given 3 indexes, draws 3 cards from the table and checks if they should be removed and point awared to player
	def draw_cards_table(indexes, players, player_name)

		# Sort and flip so the biggest indexes are at the front
		indexes.sort!.reverse!

		# Get the cards at the indexes
		cards = indexes.map {|i| @cards_on_table[i]}

		# Compute whether the three provided indexes are a card set
		is_set = Card.is_set? cards[0], cards[1], cards[2]

		# If the provided player name is playing, award/detract score as neccesary.
		# Then remove the selected cards from the table and add replacement cards if neccesary
		if players[player_name] != nil
			
			players[player_name].takes_turn cards[0], cards[1], cards[2]

			if is_set
				indexes.each { |index|
					@cards_discarded.push @cards_on_table.delete_at index
				}
				add_3_cards if @cards_on_table.size < 12
			end

		end

		# Return whether the selected triplet was a set
		is_set

	end

	# Prints the count of cards discarded and remaining
	# Also prints a numbered grid of all the cards face-up on the table, along with each card's 4-letter representation
	def print_table
		
		# Print the counts of discarded and remaining
		puts "Cards Discarded: #{@cards_discarded.size}\nCards Remaining: #{@cards_remaining.size}"

		# Print the card grid
		@cards_on_table.size.times { |i|
            print "\n" if (i % (@cards_on_table.size/3) == 0)
            print "#{"%2i" % (i+1)}: " + @cards_on_table[i].to_string + "\t\t"
        }
    end

end


	
