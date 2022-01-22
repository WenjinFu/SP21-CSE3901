/**
 * Two global variables: an array of players, and the table.
 */
let table = {
    cards_remaining: [],
    cards_on_table: [],
    cards_discarded: []
}
let players = [];

/**
 * Accessor to set the value of the players array, provided an array of string names.
 */
function set_players_from_names(player_names) {
    players = convert_names_to_players(player_names);
}

/**
 * Accessor to get the players array
 */
function get_players() {
    return players;
}

/**
 * Returns the entire this-file-scope table
 */
 function get_table() {
    return table;
}

/**
 * Takes in an array of names and converts it into an array of players for 
 * the main portion of the game.
 * 
 * Assigns each player an initial score of 0.
 */
 function convert_names_to_players(names_list) {

    return names_list.map((name_text) => {
        return {name: name_text, score: 0}
    });

}

/**
 * Returns the array of all player objects with their names and scores
 *      in descending order by score
 */
function get_players_in_order() {
    
    players = players.sort(function(a,b){return b.score-a.score});
    return players;

}

/**
 * Definition of the card class.
 * Has four properies: number, fill, color, shape.
 * Has to_string method that converts a card into a string according to README.
 * Has a constructor to create a card from a string in the same format as is produced via to_string.
 */
var card_creator = {
    
    attributes: ["numbers", "texture", "shape", "color"],
    numbers: [1, 2, 3],
    texture: ['solid', 'striped', 'open'],
    shape: ['diamond', 'squigle', 'oval'],
    color: ['red', 'purple', 'green'],
    
    numbers_chars: ["1", "2", "3"],
    textures_chars: ["S", "T", "O"],
    colors_chars: ["R", "P", "G"],
    shapes_chars: ["D", "Q", "V"],

    // Creates a card given a unique [0,81) ID
    from_numeric_ID: function(number) {
        
        // Change the number to be base 3 string before splitting it apart
        number = number.toString(3);
        // Break the base-3 number apart into an array
        var value = number.split('').map(function(i){return parseInt(i)});
        // Prepend with 0s as neccesary
        while(value.length < 4) {value .unshift(0)}

        // Create a card to return containing the values from the ID
        return { 
            value: value ,
            numbers: this.numbers[value[0]],
            texture: this.texture[value[1]],
            shape: this.shape[value[2]],
            color: this.color[value[3]],
            number_signature: value.join(""),
            string_signature: `${this.numbers_chars[value[0]]}${this.textures_chars[value[1]]}` +
                `${[this.colors_chars[value[2]]]}${this.shapes_chars[value[3]]}`
        }
    },

    // Creates a card given its string signature
    from_string_signature: function(signature) {
        // Convert the string signature into a unique number on the range [0,81). 
        // Then use the existing 'constructor'.
        let number = 27 * this.numbers_chars.indexOf(signature[0]);
            number += 9 * this.textures_chars.indexOf(signature[1]);
            number += 3 * this.colors_chars.indexOf(signature[2]);
            number += 1 * this.shapes_chars.indexOf(signature[3]);       
        return card_creator.from_numeric_ID(number);

    }

    
}



/**
 * Wrapper around a couple utility methods to create the table.
 * Creates a deck of 81 cards face-up on the table. 
 *  */ 
var deck_creator = {
    
    /**
     * Returns an array of all the possible cards, shuffled.
     */
    reset_table: function() {
        
        // Reset the array of cards, populate with all combos.
        cards = []
        while(cards.length < 81){
            cards.push(card_creator.from_numeric_ID(cards.length));
        }

        // Shuffle the deck and return
        cards = this.shuffle(cards);
        return cards;

     },

     // Shuffles the provided array (of cards)
     shuffle: function(arr) {

        for (var i = arr.length-1; i>0; i--){
            var j = Math.floor(Math.random() * (i+1));
            var temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }

        return arr;

     }
}



/**
 * Resets the provided table to an inital state by:
 *  1) Resetting the cards_remaining to a new shuffled deck
 *  2) Moving 12 of those cards into cards_on_table
 *  3) Reseting cards_discarded to an empty array
 */
function setup_table() {
    
    table.cards_remaining = deck_creator.reset_table();
    table.cards_on_table = table.cards_remaining.splice(0, 12);
    table.cards_discarded = [];

}

/**
 * Returns true if the provided array of cards contitutes a set, false otherwise.
 */
 function is_set(cards) {

    // Alias the cards into a, b, and c for ease of refernce
    let a = cards[0];
    let b = cards[1];
    let c = cards[2];
    
    /**
     * For each attribute, if they're all different 
     * OR they're all the same then the triplet is a set
     *  */ 
    return card_creator.attributes.reduce((acc, attr) => {
        return acc && (all_match(a[attr], b[attr], c[attr]) || all_different(a[attr], b[attr], c[attr]));
    }, true);

}

 /**
 * Given an array of three cards, and a player name, 
 *      increments player score if the 3 cards were a set
 *      decrements otherwise.
 * 
 * Cards are supplied as strings in the "1ORD" format.
 * 
 * Returns true if the player score was incremented.
 */
function player_make_move(card_string_signatures, player_name) {
    
    // Make cards out of the string signatures, determine if set
    let [a, b, c] = card_string_signatures.map((signature) => card_creator.from_string_signature(signature));
    let was_set = is_set([a, b, c]);

    // Find the player object with the name clicked
    let player = players.filter(p => p.name === player_name)[0];

    // If it was a set, move those cards from on_table to discarded and add new cards to the table
    if (was_set) {
        table.cards_on_table = table.cards_on_table
            .filter((card) => !card_appears_in_cards(card, [a, b, c]));
        table.cards_discarded = table.cards_discarded.concat([a, b, c]);
    }

    // Update their score accordingly
    player.score += was_set ? 1 : -1;

    return was_set;

}

/**
 * Returns true if the provided single card appears in the array cards
 */
function card_appears_in_cards(single, cards) {
    return cards.some((card) => card.string_signature === single.string_signature);
}

/**
 * Returns true if all three arguments are === equal, false otherwise.
 */
function all_match(a, b, c) {
    return a === b && a === c && b === c;
}

/**
 * Returns true if all three arguemnts are NOT === equal, false otherwise
 */
function all_different(a, b, c) {
    return a !== b && a !== c && b !== c;
}

/**
 * Returns a subset of the provided array that contitute a set.
 * Returns an empty array if none can be found.
 */
function find_set(cards) {
    // Iterate over all combos of 3. If a set is found, shuffle and return it.
    for (let i = 0; i < cards.length; i++) {
        for (let j = i+1; j < cards.length; j++) {
            for (let k = j+1; k < cards.length; k++) {
                if (is_set([cards[i], cards[j], cards[k]])) {
                    return deck_creator.shuffle([cards[i], cards[j], cards[k]]);
                }
            }
        }
    }
    // Else return emtpy array.
    return [];
}

/**
 * Returns a set of cards that are all flipped-up on the table.
 * Returns an empty array if none can be found.
 */ 
function find_set_on_table() {
    return find_set(table.cards_on_table);
}

/**
 * Returns a set of cards that are all flipped-up on the table OR in the cards_remaining pile.
 * Returns an empty array if none can be found.
 * 
 * Used to determine if the game is over.
 */ 
function find_set_on_table_and_remaining() {
    return find_set(table.cards_on_table.concat(table.cards_remaining));
}


/**
 * Moves three cards from the cards_remaining array to cards_on_table 
 * if there are enough/any to move.
 * 
 * Returns an array containing the three cards drawn.
 */
function draw_three_cards() {
    
    let new_cards = table.cards_remaining.splice(0, 3);
    table.cards_on_table = table.cards_on_table.concat(new_cards);
    return new_cards;

}

/**
 * Returns the length of the cards_remaining array
 */ 
function get_remaining_count() {
    return table.cards_remaining.length;
}

/**
 * Returns the length of the cards_discarded array
 */ 
function get_discarded_count() {
    return table.cards_discarded.length;
}

/**
 * Returns the score of the player with the supplied name.
 */
function get_player_score(player_name) {
    // Find the player object with the name clicked, return their score
    let player = players.filter(p => p.name === player_name)[0];
    return player.score;
}


