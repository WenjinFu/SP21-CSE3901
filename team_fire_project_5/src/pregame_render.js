//Global variable
var name_list = [];

/**
 * Instruction part of Game of Set.
 */
function introduction(){
    
    // Clear the existing HTML
    document.body.innerHTML = "";
    //clear names in case players use play again button
    name_list = [];

    let parent_div = document.createElement("div");
    parent_div.setAttribute("id", "pregame");

    var center_img = document.createElement("center")
    var img = document.createElement("img");
    img.setAttribute("src", "img/SET_GAME.jpg");
    img.setAttribute("alt", "SET_GAME.jpg");
    document.body.appendChild(center_img).appendChild(img);


    var h22 = document.createElement("h2");
    var h22text= document.createTextNode("GAME INSTRUCTIONS");
    h22.appendChild(h22text);
    document.body.appendChild(h22);

    var intro = document.createElement("div");
    intro.setAttribute("id", "introduction");
    intro.innerHTML=`
        <p>Game of Set is a classic card Game released by Set Enterprises in 1991.
         It supports single player/multiplayer games. What you're looking at here
          is a web version of Game of Set created by Team Fire.</p>
    `
    document.body.appendChild(intro);

    var ol1 = document.createElement("ol");

    var step1 = document.createElement("div");
    step1.setAttribute("id", "step1");
    step1.innerHTML=`
        <li>The deck contains 81 unique cards. There are four characteristics to
         the creation of cards. Each trait can be subdivided into three possibilities.
          They are the shape (diamond, squiggle, oval), the number of shapes (1,2,3),
           the shape's texture (solid, striped, open), and the shape's color (red,
             purple, green). The 81 cards will contain all the possibilities of these
              four features in random and non-repetitive combinations. Players need to
               find three cards to make a set. Each feature contained in the three cards
                is either the same or different.
        </li>
    `
    

    var step2 = document.createElement("div");
    step2.setAttribute("id", "step2");
    step2.innerHTML=`
        <li>Players need to press the "Add Names" button to start adding names. At this point, players will be prompted to 
        enter their names via the "Add" button. The page will 
         display an initialized player name table and three buttons. The "Add" button helps 
         the player add their name to the table. The "Delect" button helps the player 
         delete the last name that appears in the table. The "Ready" button starts the game!
        </li>
    `

    var step3 = document.createElement("div");
    step3.setAttribute("id", "step3");
    step3.innerHTML=`
        <li>After the "Ready" button is pressed, the page will jump to the official game interface. 
        The top row contains three buttons. After clicking the "Hint" button, a Hint is 
        given to help the player find a set by highlighting a card in a set. 
        If there is no set, new cards will be added. The "Add Cards" button will add three cards to 
        the game interface from the remaining cards on the deck. The "Quit" button will help 
        the player quit the game.
        </li>
    `

    var step4 = document.createElement("div");
    step4.setAttribute("id", "step4");
    step4.innerHTML=`
        <li>A button displaying the player's name and current score will appear below the 
        three buttons. Finding a set earns one point. You lose one point for finding a wrong set.
        </li>
    `

    var step5 = document.createElement("div");
    step5.setAttribute("id", "step5");
    step5.innerHTML=`
        <li>Twelve random cards are displayed right in the middle. On the left, the "Cards Remaining"
         button shows how many cards are left in the deck. On the right, the button "Cards Discarded"
          shows number of cards used. After finding a set, players need to click on the three cards 
          in the set, and then click on the button with their own name to complete the score update. 
          Cards that have been used cannot rejoin the game. The game continues until there are no sets remaining.
        </li>
    `

    var step6 = document.createElement("div");
    step6.setAttribute("id", "step6");
    step6.innerHTML=`
        <li>At the end of the game, the page will jump to the settlement interface. The page lists the
         player's name and score in descending order of each player's score. The player with the highest
          score will be the winner of the round and be congratulated by the game! The buttons at the 
          bottom help the player start a new round of the game.
        </li>

    `

    var step7 = document.createElement("div");
    step7.setAttribute("id", "step7");
    step7.innerHTML = `
        <li>
        For overly verbose detail on the functions of each button in the game, see the project README.
        </li></ol>
    `
    ol1.appendChild(step1);
    ol1.appendChild(step2);
    ol1.appendChild(step3);
    ol1.appendChild(step4);
    ol1.appendChild(step5);
    ol1.appendChild(step6);
    ol1.appendChild(step7);

    parent_div.appendChild(ol1);

    document.body.appendChild(parent_div);
    
    //button to start adding player names
    start_button();

}

/**
 * Initialize a table for the player names.
 */
function players_table(){

    document.getElementById("startbuttonid").disabled=true;
    var table1 = document.createElement("table");
    table1.setAttribute("id","tableid");
    var tr1=document.createElement("tr");
    var th1=document.createElement("th");
    var text1= document.createTextNode("Name");
    th1.appendChild(text1);
    tr1.appendChild(th1);
    table1.appendChild(tr1);
    document.body.appendChild(table1);

    put_players_into_table();
}

/**
 * An extension of the "Add" button.
 * Players will type their name in a pop-up window, and it will be reviewed.
 * If the name does not match the condition, the associated error statement is printed.
 * If the condition is met, the name is added to the table and stored in the array.
 */
function add_players_button(){
    var input1=window.prompt("Enter player's name");
    var tf=true;

    for(i=0;i<name_list.length;i++){
        if(name_list[i].toLowerCase()==input1.toLowerCase()){
            tf=false;
        }
    }
        if((/^[A-Za-z\s]+$/.test(input1))&&(input1!=null)&&(input1!="null")&&(input1!="NULL")&&(!(/^[\s]+$/.test(input1)))&&tf){

            var tr1=document.createElement("tr");
            var td1=document.createElement("td");
            var text1= document.createTextNode(input1);
            td1.appendChild(text1);
            tr1.appendChild(td1);
            document.body.appendChild(tr1);
            document.getElementById("tableid").appendChild(tr1);
            name_list.push(input1);
        }else if((input1==null)||(input1=="null")||(input1=="NULL")){
            window.alert("Player name cannot be null! Please try again!");
        }else if(!tf){
            window.alert("Sorry! This name is already in the table!");
        }else{
            window.alert("Currently only support letter and space input! Please try again!");
        }        

}

/**
 * An extension of the "Ready" button.
 * Without any of the names in the array, the game will not proceed to the next stage and will be given an error statement.
 * If the player's name is present in the array, the game will enter the official game interface.
 */
function add_finished(){

    if(name_list.length > 0){
        
        // Pass over the players list to the 'backend' to parse
        set_players_from_names(name_list);
        // Get the full player objects and the table back
        players = get_players();
        table = get_table();
        // Pass into the next stage of the game
        game_first_render(players, table);


    } else {
        window.alert("There are no valid names in the table now!");
    }
}

/**
 * An extension of the "Delect" button.
 * The player name in the last position is deleted.
 * If the player name does not exist in the array but the button "Delect" is still touched, the associated error statement is printed.
 */
function delete_lastrow(){
    
    var table1=document.getElementById("tableid");
    var table1length=document.getElementById("tableid").rows.length;
    if(table1length>1){
    table1.deleteRow(table1length-1);
    name_list.pop();
    }else{
        window.alert("There are no valid names in the table now!");
    }

}

/**
 * Contains buttons "Add", "Delete", and "Ready".
 * Update the table.
 */
function put_players_into_table(){

    var click1 = document.createElement("button");
    click1.setAttribute("type","button");
    click1.setAttribute("id","click1id");
    click1.setAttribute("onclick","add_players_button()");
    var text1= document.createTextNode("Add");
    click1.appendChild(text1);
    document.body.appendChild(click1);

    var click2 = document.createElement("button");
    click2.setAttribute("type","button");
    click2.setAttribute("id","click2id");
    click2.setAttribute("onclick","delete_lastrow()");
    var text2= document.createTextNode("Delete");
    click2.appendChild(text2);
    document.body.appendChild(click2);

    var click3 = document.createElement("button");
    click3.setAttribute("type","button");
    click3.setAttribute("onclick","add_finished()");
    var text3= document.createTextNode("Ready");
    click3.appendChild(text3);
    document.body.appendChild(click3);
    var click3_text = document.createElement("p");
    click3.setAttribute("id","click3id");
    document.body.appendChild(click3_text);

}


/**
 * Includes the button "Add Names".
 * The player will be asked if they want to enter the preparation phase of the game and will add their name to the table relative to it.
 * In order to prevent unnecessary errors, the "Add Names" button can only be pressed once per round.
 */
function start_button(){

    var p1 = document.createElement("p");
    p1.innerHTML=`
        <br>
        <b>
        <font color="red">
        You can only press the start button once. If you need
         to start again, please refresh the page!
         </font>
        </b>
    `
    document.body.appendChild(p1);
    var click1 = document.createElement("button");
    click1.setAttribute("type","button");
    click1.setAttribute("id","startbuttonid");
    click1.setAttribute("onclick","players_table()");
    var text1= document.createTextNode("Add Names");
    click1.appendChild(text1);
    document.body.appendChild(click1);
}

// Start pregame_render.js
introduction();

    





