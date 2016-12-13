require 'pry'
SUITS = %w(Hearts Clubs Spades Diamonds).freeze
FACES = %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King).freeze
DEALER_LIMIT = 17
WINNING_HAND = 21

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
             elsif face.to_i.zero? || face.start_with?("1")
               10
             else
               face.to_i
             end
  end

  face_value.count { |face| face.start_with?("A") }.times do
    total -= 10 if total > WINNING_HAND
  end

  total
end

def bust?(cards)
  hand_total(cards) > WINNING_HAND
end

def display_win_the_pot(player_count, dealer_count)
  if player_count == 5
    puts "Player Wins The Pot"
  elsif dealer_count == 5
    puts "Dealer Wins The Pot"
  end
end

def end_of_match?(player_count, dealer_count)
  player_count == 5 || dealer_count == 5
end

def outcome(dealer_hand, player_hand)
  puts
  puts "Dealer had #{joinand(dealer_hand)}, totaling " \
       "#{hand_total(dealer_hand)}."
  puts "You had #{joinand(player_hand)}, totaling #{hand_total(player_hand)}."
  puts
end

def another_hand?
  puts
  another_round_answer = ''
  loop do
    puts "(Y)es to play another hand, or (N)o to quit."
    another_round_answer = gets.chomp.downcase
    break if another_round_answer == 'y' || another_round_answer == 'n'
    puts "Invalid Answer.(Y)es to play another hand, or (N)o to quit."
    puts
  end
  another_round_answer == 'y'
end

def joinand(array, delimiter =', ', word = 'and')
  case array.size
  when 2 then array.join(" #{word} ")
  else
    other_array = array.dup
    other_array[-1] = "#{word} #{other_array.last}"
    other_array.join(delimiter)
  end
end

def compare_hands(player_hand, dealer_hand)
  player_hand_total = hand_total(player_hand)
  dealer_hand_total = hand_total(dealer_hand)

  if player_hand_total > WINNING_HAND
    :player_bust
  elsif dealer_hand_total > WINNING_HAND
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
    puts "You Busted with  #{joinand(player_hand)} totaling " \
         "#{hand_total(player_hand)}.Dealer Won."
  when :dealer_bust
    puts "Dealer Busted with #{joinand(dealer_hand)} totaling " \
         "#{hand_total(dealer_hand)}.You Won."
  when :player_wins
    puts "You Won"
  when :dealer_wins
    puts "Dealer Won"
  when :tie
    puts "It's a Tie"
  end
end

def display_score(player_count, dealer_count)
  puts "Your score is: #{player_count} " \
        "Dealer has: #{dealer_count}."
end

def p_win_score_pot(player_hand, dealer_hand, player_count, dealer_count)
  puts
  display_winner(player_hand, dealer_hand)
  puts
  display_score(player_count, dealer_count)
  puts
  display_win_the_pot(player_count, dealer_count)
end

def deal_hand(deck, player_hand, dealer_hand)
  2.times do
    player_hand.push(deck.shift)
    dealer_hand.push(deck.shift)
  end

  puts "Dealer has #{dealer_hand[0]} and an unknown card."
  puts "You have #{joinand(player_hand)}, totaling #{hand_total(player_hand)}."
  puts
end

player_count = 0
dealer_count = 0

loop do
  clear_screen
  deck = initialize_deck.map! { |card| card.join(" of ") }
  player_hand = []
  dealer_hand = []

  puts 'Welcome to TwentyOne'
  puts

  deal_hand(deck, player_hand, dealer_hand)

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
      puts "Your new hand is #{joinand(player_hand)}, totaling " \
           "#{hand_total(player_hand)}."
    end
    puts
    break if player_answer == 's' || bust?(player_hand)
  end

  if bust?(player_hand)
    dealer_count += 1
    p_win_score_pot(player_hand, dealer_hand, player_count, dealer_count)
    break if end_of_match?(player_count, dealer_count)
    another_hand? ? next : break
  else
    puts "You stayed with #{hand_total(player_hand)}"
    puts
  end

  puts "Dealer is thinking..."
  sleep(1)

  loop do
    break if bust?(dealer_hand) || hand_total(dealer_hand) >= DEALER_LIMIT
    puts
    puts "Dealer Hits..."
    dealer_hand.push(deck.shift)
    puts "Dealer now has #{joinand(dealer_hand)}."
    puts
  end

  if bust?(dealer_hand)
    player_count += 1
    p_win_score_pot(player_hand, dealer_hand, player_count, dealer_count)
    break if end_of_match?(player_count, dealer_count)
    another_hand? ? next : break
  else
    puts "Dealer stays with #{hand_total(dealer_hand)}"
  end

  outcome(dealer_hand, player_hand)

  case compare_hands(player_hand, dealer_hand)
  when :dealer_wins
    dealer_count += 1
  when :player_wins
    player_count += 1
  end

  display_score(player_count, dealer_count)

  break unless another_hand?
end
