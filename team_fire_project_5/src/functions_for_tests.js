
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

//Helper function
function all_match(a, b, c) {
    return a === b && a === c && b === c;
}

function all_different(a, b, c) {
    return a !== b && a !== c && b !== c;
}

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



 module.exports = is_set;
 