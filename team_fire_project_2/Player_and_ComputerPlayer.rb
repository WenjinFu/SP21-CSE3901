require_relative "card.rb"

# Wrapper class around a player's name, score, and time of last play
class Player

	#Initialize variables accessible to read/write outside class
	attr_accessor :name, :score, :time_of_last_play

	#constructor to create new Players
	def initialize(player_name)
		@name = player_name
		@score = 0
		@time_of_last_play = Time.now
	end

	#called on a Player when they take a turn
	#the Player enters the 3 cards they think are a set
	def takes_turn(card1, card2, card3)
		correct_play = Card.is_set?(card1, card2, card3)
		#if the play was correct, increment score and reset the Player's stopwatch
		#if play was incorrect, decrement score and do not reset stopwatch
		if correct_play
			@score += 1
			@time_of_last_play = Time.now
		else
			@score -= 1
		end
  end

  #will return the amount of time it has been since that player has made a play
	def time_since_last_play
		Time.now - @time_of_last_play
	end

end

#if the players choose to have a computer player, this class will be used to make the computer player at a specified difficulty level.
#the computer player will make a play after a certain amount of time depending on the difficulty. 
#after this time the computer player will find and play a set out of the cards that are on the table.
class ComputerPlayer < Player

	#initialize variables accessible for read/write outside class 
	attr_accessor :difficulty, :score, :active

	#constructor 
	#takes in the array that says whether the players want a computer player and the difficulty
	def initialize(cp_info)
		
		super "Computer"

		if cp_info.at(0).downcase == "y"
			@active = true
			@difficulty = cp_info.at(1).downcase
		else
			@active = false
		end
	end

	# Set the time that the computer player will wait before playing a set
	# If the user entered something that is not easy or hard then it will default to medium
	def cp_wait_time
		if @difficulty == "easy"
			return 60
		elsif @difficulty == "hard"
			return 10
		else
			return 30
		end 
	end

  #finds a set for the computer to play and returns an array of those 3 cards (their numbers on the table)   
  #this method is also used for giving hints to the players
  def self.find_set(cards)
	
	# Iterate over each triplet of cards
	for i in 0...cards.size
		for j in i+1...cards.size
			for k in j+1...cards.size
				# If this triplet constitutes a set, return an array containing that triplet
				return [i, j, k].shuffle! if Card.is_set? cards[i], cards[j], cards[k]
			end
		end
	end
	# If all triplets fail, return -1 populated array of length 3
	[-1, -1, -1]

  end

	#gives a card that is part of a set on the table
	#passes in an array of cards that are on the table currently
	def self.give_hint(cards_on_table)
		
		cards_in_set = ComputerPlayer.find_set(cards_on_table)
		if cards_in_set[0] != -1
			puts "You may find this card as one of the set... #{cards_in_set[0]+1}: #{cards_on_table[cards_in_set[0]].to_string}"
		else
			puts "There are no sets on the table!"
		end

	end

	# Returns a thread running the AI code and the string associated with the computer's win
	def restart_ai(cards_on_table)
	
		# Find a set in preparation for the AI to score
		set_indexes = ComputerPlayer.find_set(cards_on_table)

		# If there isn't a set, just return a thread that will die quickly and an empty string
		return ["", Thread.new {}] if set_indexes[0] == -1

		# Prepare the AI 'victory string' to print
		# The string that awards the computer the points, in the format "Computer Card# Card# Card#"
		v_string_award = "Computer " + (set_indexes.map {|i| i+1}.join " ")
		# The string that descrbes the cards the computer selected
		v_string_describe = set_indexes.map {|i| "#{cards_on_table[i].to_string}"}.join ", "
		victory_string_full = "#{v_string_award}\n#{v_string_describe}"

		# If there exists a set, start the thread with the countdown.
		thr = Thread.new(victory_string_full) { |vic_string|
			self.start_computer_player vic_string
		}

		[v_string_award, thr]

	end

	# start the computer player. it will only start making plays if active is set to true
	# needs to be called whenever the cards on the table change 
	def start_computer_player(victory_string)
		
		if @active
			# wait the designated time that the computer player needs to wait depending on difficulty
			sleep self.cp_wait_time

			# Gloat the computer's victory
			puts victory_string
			puts "Too late! The computer gets the score.\nPress enter to continue..."
		end 
	end
  
end





  
	


   
