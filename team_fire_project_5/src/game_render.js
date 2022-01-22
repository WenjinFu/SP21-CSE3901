/**
 * Emits an HTML element containing the three unchanging buttons at the top of the game:
 *  1) Hint
 *  2) Add Cards
 *  3) Quit
 */ 
 function game_fixed_buttons() {

    let parent_div = document.createElement("div");
    parent_div.setAttribute("id", "game_fixed_buttons");
    
    // Create all the buttons at once since they're completely fixed and unchanging.
    parent_div.innerHTML = `
        <div><button type="button" class="game_fixed_button" onclick="handle_hint_click()">Hint</button></div>
        <div><button type="button" class="game_fixed_button" onclick="handle_add_cards_click()">Add Cards</button></div>
        <div><button type="button" class="game_fixed_button" onclick="handle_quit_click()">Quit</button></div>
    `
    return parent_div;

}

/**
 * Callback function for handling click of the unchanging hint button
 */
function handle_hint_click() {
    
    // Iterate through all the cards and set them all to unclicked
    Array.from(document.getElementsByClassName("card")).forEach((card, index, cards) => {
        // The image is in a label is in the card div
        card.children[0].children[0].setAttribute("clicked", "false");
        card.children[0].children[0].style.border = "5px solid gray";
    });

    // Find a set
    let set = find_set_on_table();

    // If there wasn't a set, then add more cards and do nothing else.
    if (set.length === 0) {
        flip_three_cards();
        return;
    }

    // "Click" (highlight) one of the cards in the set as the hint
    let card_to_highlight_image = document.getElementById(`card_${set[0].string_signature}`).children[0].children[0];
    card_to_highlight_image.setAttribute("clicked", "true");
    card_to_highlight_image.style.border = "5px solid blue";

}

/**
 * Callback function for handling click of the unchanging 'add cards' button
 */
function handle_add_cards_click() {
    flip_three_cards();
}

/**
 * Callback function for handling click of the unchanging quit button
 */
function handle_quit_click() {
    
    // Go over and call the 'main' method in the endgame render script
    endgame_render();

}

/**
 * Emits an HTML element that is a div with a table with two columns, containing
 *  1) Player names (selectable via radio button)
 *  2) Player score
 */
function game_player_list(players_list) {

    // Create the parent div that will be returned
    let parent_div = document.createElement("div");
    parent_div.setAttribute("id", "game_player_list");

    // Create the table
    let table = document.createElement("table");
    // Append some headersi in a row
    let tr = document.createElement("tr");
    tr.innerHTML = "<th>Player Name</th><th>Score</th>"
    table.appendChild(tr);

    // For each player, add a row containing the button name and score
    players_list.forEach((player, index, array) => {
        tr = document.createElement("tr");
        let td1 = document.createElement("td");
        let td2 = document.createElement("td");

        let input = document.createElement("button");
        input.setAttribute("type", "button");
        input.setAttribute("player_name", player.name);
        input.innerHTML = player.name;
        input.onclick = player_button_callback;

        td1.appendChild(input);

        let score = document.createTextNode(player.score);
        td2.appendChild(score);

        tr.appendChild(td1);
        tr.appendChild(td2);
        table.appendChild(tr);
    });

    // Make the table the child of the parent div
    parent_div.appendChild(table);


    return parent_div;

}

/**
 * Callback function for player clicking their name button to make a set submission
 */
function player_button_callback(event) {
    
    // Get the name of the clicked player
    let player_name = event.target.getAttribute("player_name");

    // Get the list of clicked cards via their string IDs (like 1ORV)
    let face_up_cards_HTML = document.getElementsByClassName("card");
    let clicked_face_up_cards_HTML = Array.from(face_up_cards_HTML)
        .filter(card => card.children[0].children[0].getAttribute("clicked") === "true");
    let clicked_face_up_cards_strings =  clicked_face_up_cards_HTML.map(card => card.id.split("_")[1]);

    // If there's more than 3 cards, do nothing
    if (clicked_face_up_cards_strings.length !== 3) return;

    // Test if set. 
    if (player_make_move(clicked_face_up_cards_strings, player_name)) {
        
        // If yes set, remove those cards.
        clicked_face_up_cards_HTML.forEach((card, index, cards) => {
            document.getElementById("game_face_up_cards").removeChild(card);
        });
        
        // Count the cards on the table now. If less than 12, add more.
        if (document.getElementsByClassName("card").length < 12) {
            flip_three_cards();
        }

        // Update the cards discarded and cards remaining counts
        document.getElementById("cards_remaining_count").innerHTML = get_remaining_count();
        document.getElementById("cards_discarded_count").innerHTML = get_discarded_count();

    } 

    // Update the display of the player's score, which is in the table data adjacent to the clicked button
    event.target.parentNode.nextSibling.innerHTML = get_player_score(player_name);

    /**
     * Test if the game is over, which is
     *      if there's no set left in the cards on the table and cards remaining
     * 
     * If the game is over, quit
    */ 
    if ((find_set_on_table_and_remaining()).length === 0) {
        handle_quit_click();
    }

}

/**
 * Calls up the 'backend' for three cards to move the the face-up grid.
 * Adds them as HTML elements to the grid.
 * 
 * Called when any of 
 * 1) a player succesfully finds a set
 * 2) 'add more cards' button is clicked
 * 3) 'hint' button is clicked and there aren't any sets face-up on the table
 */
function flip_three_cards() {
    
    // Get three new cards from backend (if they exist)
    let new_cards = draw_three_cards();
    
    //Alias the grid of face up cards on the table
    let face_up_cards = document.getElementById("game_face_up_cards");
    
    // Add each one as an HTML element to the grid
    new_cards.forEach((card, index, cards) => {
        face_up_cards.appendChild(create_card_HTML(card));
    });

}

/**
 * Emits an HTML element that is a grid div with three columns:
 *  1) A count of cards remaining
 *  2) A grid of face-up cards on the table
 *  3) A count of cards discarded
 * 
 * Assumes table has 3 attributes: cards_on_table, cards_remaining, and cards_discarded.
 */
function game_cards_table(table) {

    // Create the parent div that will be returned
    let parent_div = document.createElement("div");
    parent_div.setAttribute("id", "game_whole_table");

    // Generate the sides of the table, which each have a label, image, and count
    let left_side = document.createElement("div");
    left_side.setAttribute("class", "game_table_side");
    let right_side = document.createElement("div");
    right_side.setAttribute("class", "game_table_side");
    left_side.innerHTML = `
        <p>Cards Remaining</p>
        <img src="img/backside.png"/>
        <p id="cards_remaining_count">69</p>
    `
    right_side.innerHTML = `
        <p>Cards Discarded</p>
        <img src="img/backside.png"/>
        <p id="cards_discarded_count">0</p>
    `

    let center_face_up_cards = document.createElement("div");
    center_face_up_cards.setAttribute("id", "game_face_up_cards");
    table.cards_on_table.forEach((card, index, cards_on_table) => {
        card_html = create_card_HTML(card);
        center_face_up_cards.appendChild(card_html);
    });


    parent_div.appendChild(left_side);
    parent_div.appendChild(center_face_up_cards);
    parent_div.appendChild(right_side);
    return parent_div;

}

/** 
 * Creates an HTML div for the supplied card.
 * Assumes card has a string signature that supplies:
 *  (1|2|3)(O|T|S)(R|G|P)(Q|D|V), like "1ORD" for "1 open red diamond".
 *  (number)(fill: Open, sTriped, Solid)(color: Red, Green, Purple)(shape: sQuigle, Diamond, oVal)
 * 
*/
function create_card_HTML(card) {    

    let card_div = document.createElement("div");
    card_div.setAttribute("class", "card");
    card_div.setAttribute("id", `card_${card.string_signature}`);
    
    let label = document.createElement("label");
    let img = document.createElement("img");
    img.setAttribute("src", `img/card/${card.string_signature}.png`);
    img.setAttribute("clicked", "false");
    label.appendChild(img);

    // Set it up so that on click the border color toggles along with the boolean attribute value "clicked"
    label.onclick = (event) => {
        // Alias the target for ease of reference
        let target = event.target;
        // Toggle the boolean clicked value
        target.setAttribute("clicked", !(target.getAttribute("clicked") === "true"));
        // Toggle the border to reflect the update
        target.style.border = target.getAttribute("clicked") === "true" ? "5px solid blue" : "5px solid gray";
    }

    card_div.appendChild(label);

    return card_div;

}

/**
 * Calls all other helper methods to render the page for the first time
 * 
 * Clears the existing html of the body
 * 
 * Assumes each player has a "name" attribute and a "score" attribute
 * 
 * Assumes table has 3 attributes: cards_on_table, cards_remaining, and cards_discarded.
 */
function game_first_render(players_list, table) {

    // Clear existing body
    document.body.innerHTML = "";

    // Add all the fixed game buttons
    document.body.appendChild(game_fixed_buttons());

    // Add the list of player names and their scores
    document.body.appendChild(game_player_list(players_list));

    // Setup the table for the beggining of the game, add its HTML.
    setup_table(table);
    document.body.appendChild(game_cards_table(table));

}



