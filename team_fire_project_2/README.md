# team_fire_project_2
Team Fire's Project #2 -- Game of Set in Ruby

HOW TO PLAY
===========
To start the game, invoke ruby on 'game.rb'.

Players will then be prompted to enter their names.   
Enter <= 14 character player names, space separated.  
Press Enter to confirm.

Players will then be prompted to choose whether to have an AI player.  
Input either 'Y' or 'y' to select yes. Any other input will register as no.  

Players will then be prompted to choose the difficulty of the AI player.  
There are 3 options: easy, medium, and hard.   
To select easy, input 'easy' or 'EASY'. To select hard, input 'hard' or "HARD". Any other input will be treaded as medium.  

Upon starting the game, four groups of information will be displayed: 
1. The Game Title and real datetime
2. A list of players: names, scores, and time since last set found (human players) / time remaining till set found (computer player)  
3. The count of discarded cards and the count of cards remaining  
4. A numbered grid of all the face-up cards on the table  
5. Prompts describing user input format.  
        a) 'add' to move 3 cards from the remaining pile to the table, if players agree there isn't a set on the table.
        b) 'exit' to quit the game. 
        c) 'hint' to be told of a card on the table that is part of a set
        d) 'PlayerName Card#1 Card#2 Card#3' to guess cards #1,2,3 for player PlayerName
            Ex: "John 8 3 12" would award 1 point to John if cards 8, 3, and 12 are a set, and detract 1 point otherwise.
            If the selected cards were a set, new cards are drawn from the remaining deck onto the table.

The game is over when there are no cards remaining on the table.

REGARDING THE COMPUTER PLAYER
=============================
The three difficulties easy, medium, and hard correspond to 60, 30, and 10 seconds before the computer player finds a set.

If a computer player is active, then any time new cards are added to the table (by adding or by drawing 3 new cards), the computer will start searching.
If the computer player's time expires, it input its guess. The computer will then be awarded its points.

Be warned: if the player adds new cards to the table, the computer will simultaneously look for multiple sets. It could then potentially score multiple times during its single countdown period.



