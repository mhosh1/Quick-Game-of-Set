#Mohamed Hosh
# 12/19/24
#
# A single card in the game
class Card
  attr_accessor :shape, :color, :number, :pattern  # Allows easy reading and updating of card properties

  # Initializes a new card with specific properties
  def initialize(shape, color, number, pattern)
    @shape = shape      # Shape of the card (e.g., oval)
    @color = color      # Color of the card (e.g., red)
    @number = number    # Number of symbols on the card (e.g., 1, 2, 3)
    @pattern = pattern  # Pattern of the symbols (e.g., solid, striped)
  end

  # Return a string description of the card
  def to_s
    "#{@shape}, #{@color}, #{@number}, #{@pattern}"  # String interpolation to show card details
  end
end

# The main game logic
class SetGame
  attr_accessor :deck, :table_cards, :player_score  # Access the deck, table cards, and player score

  def initialize
    @deck = []            # Holds all cards in the deck
    @table_cards = []     # Cards currently on the table (12 at a time)
    @player_score = 0     # Track the player's score
    create_deck           # Create all the cards for the deck
    shuffle_and_deal      # Shuffle deck and deal 12 cards to the table
  end

  # Create every possible combination of shape, color, number, and pattern
  def create_deck
    shapes = ['oval', 'diamond', 'squiggle']
    colors = ['red', 'green', 'purple']
    numbers = [1, 2, 3]
    patterns = ['solid', 'striped', 'empty']

    # Nested loops to generate all card combinations
    shapes.each do |shape|
      colors.each do |color|
        numbers.each do |number|
          patterns.each do |pattern|
            @deck << Card.new(shape, color, number, pattern)  # Add each new card to the deck
          end
        end
      end
    end
  end

  # Shuffle the deck and deal 12 cards to the table
  def shuffle_and_deal
    @deck.shuffle!  # Shuffle the deck
    @table_cards = @deck.pop(12)  # Deal 12 cards from the deck
    show_table_cards              # Display the cards on the table
  end

  # Show the cards currently on the table
  def show_table_cards
    puts "\nCards on the table:\n"
    @table_cards.each_with_index do |card, index|
      puts "#{index + 1}: #{card}"  # Print each card with its position number
    end
  end

  # Get input from the player and check if they selected a valid set
  def get_player_input
    puts "\nPick 3 card numbers (e.g., 1, 5, 9):"
    input = gets.chomp  # Get player input
    selected_indexes = input.split(',').map { |i| i.to_i - 1 }  # Convert input to array of indices

    if selected_indexes.size == 3
      chosen_cards = selected_indexes.map { |i| @table_cards[i] }  # Get the chosen cards
      if valid_set?(chosen_cards[0], chosen_cards[1], chosen_cards[2])
        puts "\nCorrect set! Replacing cards..."
        replace_cards(selected_indexes)
        @player_score += 1
        puts "\nYour score: #{@player_score}"
      else
        puts "\nNot a valid set. Try again!"
      end
    else
      puts "\nPlease choose exactly 3 cards."
    end
  end

  # Check if 3 cards form a valid set
  def valid_set?(card1, card2, card3)
    shapes_match = [card1.shape, card2.shape, card3.shape].uniq.size != 2
    colors_match = [card1.color, card2.color, card3.color].uniq.size != 2
    numbers_match = [card1.number, card2.number, card3.number].uniq.size != 2
    patterns_match = [card1.pattern, card2.pattern, card3.pattern].uniq.size != 2

    # Return true if all properties either all match or all differ
    shapes_match && colors_match && numbers_match && patterns_match
  end

  # Replace the 3 chosen cards with new ones from the deck
  def replace_cards(indexes)
    indexes.each do |i|
      if @deck.empty?
        puts "\nNo more cards to replace!"
        break
      else
        @table_cards[i] = @deck.pop  # Replace the chosen cards with new ones
      end
    end
    show_table_cards  # Show the updated table cards
  end

  # Start the game
  def play
    puts "\nWelcome to the Game of Set!\n"
    while @deck.size > 0
      get_player_input  # Keep asking the player for input until the deck is empty
    end
    puts "\nGame over! Your final score: #{@player_score}"
  end
end

# Start a new game
game = SetGame.new
game.play