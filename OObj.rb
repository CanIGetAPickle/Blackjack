class String
  def red;     "\033[31m#{self}\033[0m" end
  def green;   "\033[32m#{self}\033[0m" end
  def magenta; "\033[35m#{self}\033[0m" end
  def cyan;    "\033[36m#{self}\033[0m" end
  def bg_blue; "\033[44m#{self}\033[0m" end
  def bg_red;  "\033[41m#{self}\033[0m" end
  def bg_cyan; "\033[46m#{self}\033[0m" end
end

class Deck
  attr_accessor :vals, :suits, :cards
  
  def initialize
    @vals = %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King)
    @suits = %w(Spades Clubs Hearts Diamonds)
    @cards = vals.product(suits)
  end

  def shuffle!
   cards.shuffle!
  end
end
  
module Hand

  def total
    card_values = cards.map{ |card| card[0] }

    total = 0
    card_values.each do |val|
      if val == "Ace"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end
    card_values.select{ |value| value == "Ace" }.count.times do
      if total <= 21
        break
      else
        total -= 10
      end
    end
    total
  end
end
  
class Player
  include Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def add_card(new_card)
    cards << new_card
  end
end

class Game
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Player.new
  end

  def initial_deal
    2.times do
      player.add_card(deck.cards.pop)
      dealer.add_card(deck.cards.pop)
    end
  end

  def show_player_cards
    puts
    puts ">>> Your cards:".magenta
    print ">>> "
    player.cards.each { |card| print "[#{card[0]} of #{card[1]}] " }
    print "--- Total: #{player.total} ---"
    puts
  end

  def show_dealer_cards
    puts
    puts ">>> Dealer's cards:".green
    print ">>> First card hidden. [#{dealer.cards[1][0]} of #{dealer.cards[1][1]}] "
    puts
  end

  def reveal_dealer_cards
    print ">>> Dealer's cards: ".green
    dealer.cards.each { |card| print "[#{card[0]} of #{card[1]}] " }
    print "for a total of #{dealer.total}."
    puts
  end

def check_for_winner
    if player.total > dealer.total && player.total <= 21
      puts
      puts ">>> Congratulations, you win!".bg_cyan
    elsif dealer.total > player.total && dealer.total <= 21
      puts
      puts ">>> Sorry, you lose!".bg_cyan
    elsif player.total == dealer.total && player.total <= 21 && dealer.total <= 21
      puts
      puts ">>> It's a tie!".bg_cyan
    end
    play_again?
  end

  def check_for_blackjack_or_bust
    if player.total == 21
      puts
      puts ">>> Blackjack! You win!".bg_blue
      play_again?
    elsif player.total > 21
      puts
      puts ">>> Busted! You lose!".bg_red
      play_again?
    elsif dealer.total == 21
      reveal_dealer_cards
      puts
      puts ">>> Dealer hit blackjack! You lose!".bg_red
      play_again?
    elsif dealer.total > 21
      reveal_dealer_cards
      puts
      puts ">>> Dealer busted with a total of #{dealer.total}! You win!".bg_blue
      play_again?
    end
  end

  def player_turn
    check_for_blackjack_or_bust
    while player.total < 21
      puts
      puts ">>> Your turn. Choose a number: (1) Hit (2) Stay".cyan
      response = gets.chomp.to_i
      if response == 1
        new_card = deck.cards.pop
        puts ">>> Dealing you a new card: [#{new_card[0]} of #{new_card[1]}]".magenta
        player.add_card(new_card)
        puts ">>> Your total is now: #{player.total}".magenta
        check_for_blackjack_or_bust
      elsif response == 2
        puts ">>> You chose to stay at #{player.total}.".magenta
        puts
        break
      else
        puts ">>> Invalid input. Please pick 1 or 2.".red
        player_turn
      end
    end
  end

  def dealer_turn
    check_for_blackjack_or_bust
    puts ">>> Dealer's turn...".cyan
    puts
    while dealer.total < 17
      new_card = deck.cards.pop
      puts ">>> Dealing card to dealer: #{new_card[0]} of #{new_card[1]}".green
      dealer.add_card(new_card)
      check_for_blackjack_or_bust
    end
    puts ">>> Dealer stays.".green
    reveal_dealer_cards
  end

  def play_again?
    puts
    puts ">>> Would you like to play again? (1) Yes (2) No".cyan
    if gets.chomp == '1'
      @deck = Deck.new
      player.cards = []
      dealer.cards = []
      play
    else
      puts ">>> Goodbye!".cyan
      exit
    end
  end

  def play
    deck.shuffle!
    initial_deal
    show_dealer_cards
    show_player_cards
    check_for_blackjack_or_bust
    player_turn
    dealer_turn
    check_for_winner
  end
end

game = Game.new.play
