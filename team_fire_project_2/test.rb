require "minitest/autorun"

require_relative "card.rb"
require_relative "Player_and_ComputerPlayer.rb"
require_relative "utility.rb"

#Test some methods of the Card class
class TestCard < MiniTest::Test
    #From test_to_string 1-4, we will test to_string method
    #If the output matches the desired string, the test passes
    def test_to_string1
        test1=Card.new 1,1,1,1
        out1=test1.to_string
        assert_equal("1SRD", out1)
    end

    def test_to_string2
        test2=Card.new 2,2,2,2
        out2=test2.to_string
        assert_equal("2TGQ", out2)
    end

    def test_to_string3
        test3=Card.new 4,4,4,4
        out3=test3.to_string
        assert_equal("3OPV", out3)
    end

    def test_to_string4
        test4=Card.new 1,2,4,2
        out4=test4.to_string
        assert_equal("1TPQ", out4)
    end

    #From test_selfset 1-4, we will test self.is_set? method of card class
    #This method tests whether the three selected cards form a set
    #If the return value matches the ideal value, the test succeeds
    def test_selfset1
        a1=Card.new 1,1,1,1
        b1=Card.new 2,2,2,2
        c1=Card.new 4,4,4,4
        result=Card.is_set?(a1,b1,c1)
        assert_equal(true, result)

    end

    def test_selfset2
        a2=Card.new 1,1,1,1
        b2=Card.new 1,1,1,1
        c2=Card.new 1,1,1,1
        result=Card.is_set?(a2,b2,c2)
        assert_equal(true, result)

    end

    def test_selfset3
        a3=Card.new 1,1,4,4
        b3=Card.new 1,2,4,2
        c3=Card.new 1,4,4,4
        result=Card.is_set?(a3,b3,c3)
        assert_equal(false, result)

    end

    def test_selfset4
        a4=Card.new 1,2,1,1
        b4=Card.new 2,2,1,4
        c4=Card.new 2,4,4,4
        result=Card.is_set?(a4,b4,c4)
        assert_equal(false, result)

    end
end

#Test some methods of the Computer Player class
class TestAI < MiniTest::Test

    # Testing to ensure that the find_set method works when there IS a set
    def test_find_set1
    
        # Generate the full deck
        full_deck = Utility.new_deck

        # Make deck of cards on the table
        on_table = [] 
        2.times {on_table.push full_deck.shift}

        # Add the complement of the two cards currently on the table to ensure there's a set
        on_table.push Card.complement on_table[0], on_table[1]

        # Find the resulting set (method under test)
        set = ComputerPlayer.find_set on_table

        # Assert that the first resulting index is not -1
        assert_equal(false, set[0] == -1)
    
    end

        # Testing to ensure that the find_set method works when there ISN'T a set
        def test_find_set2
    
            # Generate the full deck
            full_deck = Utility.new_deck
    
            # Make deck of cards on the table
            on_table = [] 
            2.times {on_table.push full_deck.shift}
    
            # Add the complement of the two cards currently on the table to ensure there's a set
            complement = Card.complement on_table[0], on_table[1]
            if complement.card_matches? full_deck[0]
                on_table.push full_deck.delete_at 1
            else
                on_table.push full_deck.delete_at 0
            end

    
            # Find the resulting set (method under test)
            set = ComputerPlayer.find_set on_table
    
            # Assert that the first resulting index is -1
            assert_equal(true, set[0] == -1)
        
        end


end