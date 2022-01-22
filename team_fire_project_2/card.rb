
# Class for encapsulating cards. Handles all the 4 properties of cards.
# Contains methods for making cards and comparing cards.
class Card

    # Instance variables all readable and writeable
    attr_accessor :num
    attr_accessor :texture
    attr_accessor :color
    attr_accessor :shape

    # Values for the various 'measures' of cards (number, color, shape, texture)
    VALUES = [0b1, 0b10, 0b100]

    # The count of values that any card property has
    VALUE_COUNT = VALUES.size

    # The OR of all the values cards can take on
    ALL = VALUES[0] | VALUES[1] | VALUES[2]

    # The three numbers cards can take on
    NUMBERS = {VALUES[0] => 1, VALUES[1] => 2, VALUES[2] => 3}
    # The 1-char representation of numbers
    NUMBERS_CHARS = {VALUES[0] => '1', VALUES[1] => '2', VALUES[2] => '3'}

    # The three colors cards can take on
    COLORS = {VALUES[0] => "Red", VALUES[1] => "Green", VALUES[2] => "Purple"}
    # The 1-character representation of colors
    COLORS_CHARS = {VALUES[0] => "R", VALUES[1] => "G", VALUES[2] => "P"}

    # The three shapes cards can take on
    SHAPES = {VALUES[0] => "Diamond", VALUES[1] => "Squigle", VALUES[2] => "Oval"}
    # The 1-character representation of shapes
    SHAPES_CHARS = {VALUES[0] => "D", VALUES[1] => "Q", VALUES[2] => "V"}

    # The three textures cards can take on
    TEXTURES = {VALUES[0] => "Solid", VALUES[1] => "Striped", VALUES[2] => "Open"}
    # The 1-character representation of textures
    TEXTURES_CHARS = {VALUES[0] => "S", VALUES[1] => "T", VALUES[2] => "O"}

    # Basic constructor
    def initialize(given_num , given_texture, given_color, given_shape)
        @num = given_num
        @texture = given_texture
        @color = given_color
        @shape = given_shape
    end

    # Converts a single card into its 4-character string representation 
    def to_string
        # Order of adjectives is number texture color (shape noun)
        # "three solid green diamonds"
        out = ""
        out += NUMBERS_CHARS[@num] 
        out += TEXTURES_CHARS[@texture]
        out += COLORS_CHARS[@color] 
        out += SHAPES_CHARS[@shape] 
        out 
    end

    # returns true if the self card matches the provided
    def card_matches?(c)
        @num == c.num && @texture == c.texture && @color == c.color && @shape == c.shape
    end

    # returns true if the 3 provided cards constitute a set
    def self.is_set?(a, b, c)

        c.card_matches? (Card.complement a,b)

    end

    # Returns a card that together with a and b constitute a set
    def self.complement(a, b)
    
        # For each attribute:
        #  If the two cards match, then the complimentary cards attribute matches
        #  If the two cards don't match, then the bit complement is the complement
        num = a.num == b.num ? a.num : ALL ^ (a.num | b.num)
        texture = a.texture == b.texture ? a.texture : ALL ^ (a.texture | b.texture)
        color = a.color == b.color ? a.color : ALL ^ (a.color | b.color)
        shape = a.shape == b.shape ? a.shape : ALL ^ (a.shape | b.shape)

        Card.new num, texture, color, shape
    
    end



    

end