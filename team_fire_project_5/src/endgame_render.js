/**
 * Clears the existing body of the HTML and renders:
 *  1) Some message congradulating the winning player
 *  2) A table of all player names and scores
 *  3) A button to return back to the beggining of the game
 */
function endgame_render() {
    
    // Clear the existing HTML
    document.body.innerHTML = "";
    
    let parent_div = document.createElement("div");
    parent_div.setAttribute("id", "endgame");

    //end of game image
    var center_img = document.createElement("center")
    var img = document.createElement("img");
    img.setAttribute("src", "img/GAME_OVER.png");
    img.setAttribute("alt", "Game Over!");
    document.body.appendChild(center_img).appendChild(img);
    //get the players list and sort in order of score 
    players_list = get_players_in_order();

    
    // declare the winner
    winner = players_list[0].name
    var h2 = document.createElement("h2");
    var h2text = document.createTextNode("The winner is: " + winner);
    h2.appendChild(h2text);
    document.body.appendChild(h2);
    
    // Create the table 
    var table = document.createElement("table");
    // table headers
    var tr = document.createElement("tr");
    tr.innerHTML = "<th>Player Name</th><th>Score</th>"
    table.appendChild(tr);

    // List players and scores in order from highest score to lowest
    players_list.forEach((player) => {
    tr = document.createElement("tr");
    var td1 = document.createElement("td");
    var td2 = document.createElement("td");
    var name = document.createTextNode(player.name);
    td1.appendChild(name);
    var score = document.createTextNode(player.score);
    td2.appendChild(score);

    tr.appendChild(td1);
    tr.appendChild(td2);
    table.appendChild(tr);
    });
    document.body.appendChild(table);

    //create the play again button
    var playagain = document.createElement("button");
    playagain.setAttribute("type", "button");
    playagain.setAttribute("id", "playagainbuttonid");
    playagain.setAttribute("onclick", "introduction()");
    var text1 = document.createTextNode("Play Again!");
    playagain.appendChild(text1);
    document.body.appendChild(playagain);

    document.body.appendChild(parent_div);



}
