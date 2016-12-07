
SUITS = %w(Hearts Clubs Spades Diamonds).freeze
FACES = %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King).freeze
DEALER_LIMIT = 17

def initialize_deck
  FACES.product(SUITS).shuffle
end

def clear_screen
  system('cls') || system('clear')
end

def hand_total(cards)
  face_value = cards.map { |card| card[0] }

  total = 0

  face_value.each do |face|
    total += if face.start_with?("A")
               11
             elsif face.to_i.zero?
               10
             elsif face.start_with?("1")
               10
             else
               face.to_i
             end
  end

  face_value.count{ |face| face.start_with?("A") }.times do
    total -= 10 if total > 21
  end

  total
end

def bust?(cards)
  hand_total(cards) > 21
end

def outcome(dealer_hand, player_hand)
  puts
  puts "Dealer had #{joinor(dealer_hand)}, totaling #{hand_total(dealer_hand)}"
  puts "You had #{joinor(player_hand)}, totaling #{hand_total(player_hand)}"
  puts
end

def another_hand?
  puts
  puts "(Y)es to play another hand, or anything else to quit."
  another_round_answer = gets.chomp.downcase
  another_round_answer == 'y'
end

def joinor(array, delimiter =', ', word = 'and')
  case array.size
  when 2 then array.join(" #{word} ")
  else
    array[-1] = "#{word} #{array.last}"
    array.join(delimiter)
  end
end

def compare_hands(player_hand, dealer_hand)
  player_hand_total = hand_total(player_hand)
  dealer_hand_total = hand_total(dealer_hand)

  if player_hand_total > 21
    :player_bust
  elsif dealer_hand_total > 21
    :dealer_bust
  elsif player_hand_total > dealer_hand_total
    :player_wins
  elsif dealer_hand_total > player_hand_total
    :dealer_wins
  else
    :tie
  end
end

def display_winner(player_hand, dealer_hand)
  result = compare_hands(player_hand, dealer_hand)

  case result
  when :player_bust
    puts "You Busted with #{hand_total(player_hand)}.Dealer Won"
  when :dealer_bust
    puts "Dealer Busted with #{hand_total(dealer_hand)}.You Won"
  when :player_wins
    puts "You Won"
  when :dealer_wins
    puts "Dealer Won"
  when :tie
    puts "It's a Tie"
  end
end

loop do
  deck = initialize_deck.map! { |card| card.join(" of ") }
  player_hand = []
  dealer_hand = []

  clear_screen
  puts 'Welcome to TwentyOne'
  puts

  2.times do
    player_hand.push(deck.shift)
    dealer_hand.push(deck.shift)
  end

  puts "Dealer has #{dealer_hand[0]} and an unknown card."
  puts "You have #{joinor(player_hand)}, totaling #{hand_total(player_hand)}."
  puts

  loop do
    player_answer = nil

    loop do
      puts "Would you like to (h)it or (s)tay?"
      player_answer = gets.chomp.downcase
      break if player_answer == 'h' || player_answer == 's'
      puts "Invalid answer, Would you like to (h)it or (s)tay?"
    end

    if player_answer == 'h'
      player_hand.push(deck.shift)
      puts "Your new hand is #{joinor(player_hand)}, totaling " +
      "#{hand_total(player_hand)}."
    end
    puts
    break if player_answer == 's' || bust?(player_hand)
  end

  if bust?(player_hand)
    display_winner(player_hand, dealer_hand)
    another_hand? ? next : break
  else
    puts "You stayed with #{hand_total(player_hand)}"
    puts
  end

  puts "Dealer is thinking..."
  sleep(2)

  loop do
    break if bust?(dealer_hand) || hand_total(dealer_hand) >= DEALER_LIMIT
    puts
    puts "Dealer Hits..."
    dealer_hand.push(deck.shift)
    puts "Dealer now has #{joinor(dealer_hand.fill(' An unknown card ', 1, 1))}."
    puts
  end

  if bust?(dealer_hand)
    display_winner(player_hand, dealer_hand)
    another_hand? ? next : break
  else
    puts "Dealer stays with #{hand_total(dealer_hand)}"
  end

  outcome(dealer_hand, player_hand)

  display_winner(player_hand, dealer_hand)
  break unless another_hand?
end