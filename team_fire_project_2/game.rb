require_relative "card.rb"
require_relative "utility.rb"
require_relative "table.rb"
require_relative "Player_and_ComputerPlayer.rb"

# Class containing the table and hash of players
# Is the "Driver Class" that prints out the game and processes user input
# Executable "Main Method" code at the bottom
class Game
    
    # Hash of players
    attr_accessor :players
    # Reference to table object tracking the decks of cards
    attr_accessor :table

    # Thread for running the AI in
    attr_accessor :ai_thread

    # The maximum allowable name length (fits in two 8-wide tabs with : and space)
    MAX_NAME_LENGTH = 14

    def initialize

        # Initialize the table and its 3 decks
        @table = Table.new

        # Clear the screen, draw the rectangular game start graphic
        system "clear"
        Utility.draw_rectangle

        #Ask human players to type in all names at once and each name should be separated by a space, such as Joe Lucy.
        print "\nPlease enter player names, space separated (#{MAX_NAME_LENGTH} characters or shorter):\n>> "
        names = gets.chomp.split.map {|name| name[0...MAX_NAME_LENGTH]}

        # Create a player for each name, put them all on the players hash
        @players = {}
        names.each {|name| @players[name] = Player.new name}

        # Output some simple game welcome text according to the human player names
        print "Hi, "
        # Use a utility method for handling printing a list corrrectly (with correct "," and ", and")
        Utility.print_list names
        puts "!\nWelcome to the game of set!"

        # Initialize an array of size 2 to store the computer player's information.
        # computerplayer info = [(y/n) -- whether to have a cpu player, (easy/medium/hard) -- difficulty]
        computer_player_info = Array.new 2

        # Get the necessary information about the computer player from the human player
        print "Do you need a computer player to join the game? [Y/N] \n>> "
        computer_player_info[0] = gets.chomp
        # If they selected yes to the CPU player, prompt for the difficulty
        if computer_player_info[0].downcase == "y"
            print "Smart decision! What level of difficulty do you want? [easy/medium/hard]\n>> "
            computer_player_info[1] = gets.chomp

            # Add the computer player to the players hash
            computer_player = ComputerPlayer.new computer_player_info
            @players[computer_player.name] = computer_player
        else
            puts "Great! Enjoy your game!"
        end

    end

    # Main loop that's repeated until all cards are discarded
    def game_loop
        
        # Start the AI if it exists
        computer_win_string, @ai_thread = @players["Computer"].restart_ai @table.cards_on_table if @players["Computer"] != nil

        while @table.cards_discarded.size < 81
            
            # Clear the console
            system "clear"

            # Print "Game of Set" title and real time
            time_string = Time.now.strftime "%A, %b %d, %I:%M %p"
            puts "GAME OF SET\t\t#{time_string}\n\n"

            # Print the players and the table
            Utility.print_players @players
            @table.print_table

            # Give the user prompts
            puts "\n\nType 'add' to 3 cards to the table."
            puts "Type 'exit' to quite the game."
            puts "Type 'hint' to get a hint." 
            puts "Type 'name # # #' to select a 3-card set for player name."
            print "\n>> "

            # Read the input and process it. Don't bother if computer already won
            input = gets.chomp unless @players["Computer"] != nil && computer_win_string != "" && !@ai_thread.alive?
            # Quit game if input directed exit
            break if input == "exit"
            # If the computer win string is nonempty and the ai thread is expired, override user input with ai win string
            input = computer_win_string if @players["Computer"] != nil && computer_win_string != "" && !@ai_thread.alive?
            
            # Get the next computer wing string
            computer_win_string = process_input input, computer_win_string

        end

        # Farewell the players
        end_game

    end

    # Handles the input typed by players in-game
    def process_input(input, old_computer_win_string)
        if input == "add"
            # Let the table handle moving 3 cards from cards_remaining to cards_on_table
            @table.add_3_cards

            # Since new cards were added to the table, restart the AI and return the new win string
            computer_win_string, @ai_thread = @players["Computer"].restart_ai @table.cards_on_table if @players["Computer"] != nil
            return computer_win_string

        elsif input == "hint"
            # If the user asked for a hint, print one then pause till they hit enter
            ComputerPlayer.give_hint @table.cards_on_table
            puts "Press enter to continue..."
            gets

            # Since no new cards were added, return the old win string
            return old_computer_win_string

        elsif input.split.size == 4
            # This is the selection for when a player is guessing a set
            # Input format here is {PlayerName, Card#1, Card#2, Card#3}
            split = input.split
            
            # Get the card numbers (indexes)
            indexes = split[1...4]
            indexes.map! {|num_string| (num_string.to_i) - 1}
            
            # Let the table handle the awarding of points and adding of new cards
            @table.draw_cards_table indexes, @players, split[0]
        
            # Since new cards were added to the table, restart the AI and return the new win string
            computer_win_string, @ai_thread = @players["Computer"].restart_ai @table.cards_on_table if @players["Computer"] != nil
            return computer_win_string

        elsif input == ""
            # Just do nothing and redraw if the user pressed enter and nothing else
            # Since no new cards were added, return the old win string
            return old_computer_win_string
        else
            # Catch all message for bad input
            puts "Input not understood. Press enter to continue..."
            gets

            # Since no new cards were added, return the old win string
            return old_computer_win_string
        end
    end

    # Method to print goodbyes and graphics when the game ends
    def end_game
        # Draw the goodbye trees graphic
        Utility.draw_tree
    end

end

# The executable code, or 'main method' to start the game
g = Game.new
g.game_loop
