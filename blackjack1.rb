def add_card_values(cards)
  array_of_cards = cards.map{|card_value| card_value[0] }

  total_value = 0
  array_of_cards.each do |value|
    if value == "Ace"
      total_value += 11
    elsif value == "Jack" || value == "Queen" || value == "King"
      total_value += 10
    else
      total_value += value.to_i
    end
  end

  array_of_cards.select{|aces| aces == "Ace"}.count.times do
    if total_value > 21
      total_value -= 10 
    end
  end

  total_value
end

def print_cards(cards)
  cards.each{ |card| print " [#{card[0]} of #{card[1]}]"}
end

def play_again_message
  puts "::: Play again? (Y/N) :::"
  play_again = gets.chomp.upcase
  exit if play_again != "Y"
end

play_again = "Y"

until play_again != "Y"
  card_values = %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King)
  card_suits = %w(Spades Clubs Hearts Diamonds)

  deck = card_values.product(card_suits).to_a

  deck.shuffle!

  player_cards = []
  dealer_cards = []

  2.times do
    player_cards.push(deck.pop)
    dealer_cards.push(deck.pop)
  end

  dealer_total = add_card_values(dealer_cards)
  player_total = add_card_values(player_cards)

  print ">>> Dealer's cards:"
  print_cards(dealer_cards)
  print ". Dealer's total: #{dealer_total}. "
  puts ""
  print ">>> Your cards:" 
  print_cards(player_cards)
  print ". Your total: #{player_total}. "
  puts ""

  if player_total == 21
    puts ">>> Blackjack -- you win!"
    play_again_message
  end

  while player_total < 21
    puts ">>> What would you like to do? Enter '1' to hit or '2' to stay."
    hit_or_stay = gets.chomp

    if hit_or_stay != "1" && hit_or_stay != "2"
      puts ">>> That's not a valid choice! Try again."
      next
    end
    if hit_or_stay == "2"
      puts ">>> You stay with #{player_total}."
      break
    end

    new_card = deck.pop
    player_cards.push(new_card)
    player_total = add_card_values(player_cards)
    puts ">>> Dealer gives you [#{new_card[0]} of #{new_card[1]}] for a total of #{player_total}."

    if player_total == 21
      puts ">>> Blackjack -- you win!"
      play_again_message
    elsif player_total > 21
      puts ">>> You busted -- dealer wins!"
      play_again_message
    end
  end

  if dealer_total == 21
    puts ">>> Blackjack -- dealer wins!"
    play_again_message
  end

  while dealer_total < 17
    new_card = deck.pop
    dealer_cards.push(new_card)
    dealer_total = add_card_values(dealer_cards)
    puts ">>> Dealer deals herself [#{new_card[0]} of #{new_card[1]}] for a total of #{dealer_total}."

    if dealer_total == 21
      puts ">>> Blackjack -- dealer wins!"
      play_again_message
    elsif dealer_total > 21
      puts ">>> Dealer busted -- you win!"
      play_again_message
    end
  end

  puts ">>> Dealer's cards: "
  print_cards(dealer_cards)
  puts ""
  puts ">>> Your cards:"
  print_cards(player_cards)
  puts ""

  if dealer_total > player_total
    puts ">>> Sorry, dealer wins."
  elsif dealer_total < player_total
    puts ">>> Congratulations, you win!"
  else
    puts ">>> It's a tie!"
  end

  play_again_message
end

exit