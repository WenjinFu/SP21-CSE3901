# team_fire_project_5
Team Fire Project 5 -- Game of Set in JavaScript

Written by:  
------------
Wenjin Fu  
Gabby Rigol  
Michael Taylor  
Yu Xiong  

How to Use
===========
1) For testing, install jest via 'npm install jest'. Test suite then executable via 'npm test'.
2) To open and play the game, open index.html in firefox.

Project Design
=============================
The game is broken into 3 stage scripts with one supporting game logic script.  
The script associated with each stage is only responsible for interacting with the document HTML and rendering changes.
## 1. The pregame stage render script
This script is responsible for two things:
1) Detailing instructions on how to play the game. To do this, this script just emits DIV elements containing list items detailing how to play at each stage of the game.
2) Allowing users to input their names before a game starts. This is achieved by clicking the single "Add Players" button, which creates three more buttons with the following functions:
	1) 'Add' prompts the users to input a new playername. Before adding the playername to the list, it calls logic that checks that the name is both composed of only alphabetical characters/spaces AND is NOT already a playername on the list. This is to prevent repeat playernames.
    2) 'Delete' removes the most recent playername from the list.
    3) 'Ready' starts the game by moving on to the next stage of the game (playing).
## 2. The game stage render script
This script contains the event handlers for the 'main' section of the game -- while it is being played.  
It emits three principle HTML elements:
1) A triplet of buttons that the user interacts with: "Hint", "Add Cards", "Quit". Their functions are as follows: 
	1) The "Hint" button deselects/unclicks all cards on the table, then selects/clicks exactly one random card the computer determines to be in a set. If there is no set on the table, then the Hint button adds cards to the table exactly the like Add Cards button does.
    2) The "Add Cards" button takes three cards from the yet-to-be-played "cards remaining" pile and flips them face up on to the table. If there are not enough cards to move from the remaining pile to the table, it does nothing.
    3) The "Quit" button takes the players to the endgame screen where the player with the highest score is congratulated and the players and their scores are listed in descending order beneath.
2) A table containing a button for each player and each player's score. Clicking the button submits a set to logic which checks if the selected triplet are a set (If more or less than 3 cards are selected, nothing happens). If the selected cards constitute a set, it awards the clicking player a point, else it detracts a point.
3) A grid of three columns. In the first is text and an image representing the cards yet to be dealt ("cards remaining") and their count. In the third is the same thing representing cards already used ("cards discarded"). In the middle is a grid of clickable cards a player can select and deselect as they choose their sets.
## 3. The postgame stage render script
This script emits four main HTML elements:
1) An endgame image
2) A congratulations to the winning player with the highest score. If highest score is tie, the congratulated winner is arbitrary between players with the highest score. 
3) A table containing players and their scores and descending order
4) A button to restart
## 4. The logic script
Cards are described via a card class containing the four measures of a 'game of set' card:  
1. Number, which can take on the values **1**, **2**, **3** (1, 2, 3)
2. Fill, which can take on the values **s**olid, s**t**riped, **o**pen (S, T, O)
3. Color, which can take on the values **r**ed, **g**reen, **p**urple (R, G, P)
4. Shape, which can take on the values s**q**uigle, **d**iamond, o**v**al (Q, D, V)  

Thus, by the 1-character letterings above, any card can be described via a 4-character string.  
For example, "two striped green squigles" is written "2TGQ".  
This is the means by which this game internally represents cards as strings when neccesary.  

This file also handles all 'backend' logic that might be required by any of the three rendering files, like determining whether arrays of cards are sets, producing all the combinations of cards, ensuring no repeat playernames, etc...
