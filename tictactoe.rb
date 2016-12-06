

INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]].freeze

puts 'Welcome to Tic Tac Toe v1.0'
puts

def clear_screen
  system('clear') || system('cls')
end

def show_board(brd)
  puts "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}"
  puts " #{brd[1]} | #{brd[2]} | #{brd[3]} "
  puts '---+---+---'
  puts " #{brd[4]} | #{brd[5]} | #{brd[6]} "
  puts '---+---+---'
  puts " #{brd[7]} | #{brd[8]} | #{brd[9]} "
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select do |key, value|
      line.include?(key) && value == INITIAL_MARKER
    end.keys.first
  end
end

def joinor(array, delimiter =', ', word = 'or')
  case array.size
  when 0 then ''
  when 1 then array.first
  when 2 then array.join(" #{word} ")
  else
    array[-1] = "#{word} #{array.last}"
    array.join(delimiter)
  end
end

def first_move
  first_move_answer = ''
  loop do
    puts "Choose who makes the first move , type p for Player or c for Computer"
    first_move_answer = gets.chomp.downcase
    break if first_move_answer == 'p' || first_move_answer == 'c'
    puts "Invalid answer, Please type p for Player or c for Computer"
  end

  if first_move_answer == 'p'
    "Player"
  else
    "Computer"
  end
end

def alternate_player(current_player)
  if current_player == "Player"
    "Computer"
  else
    "Player"
  end
end

def place_piece!(brd, current_player)
  if current_player == "Player"
    player_move!(brd)
  else
    computer_move!(brd)
  end
end

def player_move!(brd)
  choice = ''
  loop do
    puts "Choose a square #{joinor(empty_squares(brd), ', ')}"
    choice = gets.chomp.to_i
    break if empty_squares(brd).include?(choice)
    puts 'Sorry your choice was invalid. Please choose again'
  end
  brd[choice] = PLAYER_MARKER
end

def computer_move!(brd)
  clear_screen
  choice = nil

  # smart-move
  WINNING_LINES.each do |line|
    choice = risk_square(line, brd, COMPUTER_MARKER) ||
             risk_square(line, brd, PLAYER_MARKER)
    break if choice
  end

  unless choice
    choice = 5 if brd[5] == INITIAL_MARKER
  end

  choice = empty_squares(brd).sample unless choice

  brd[choice] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def someone_won?(brd)
  !!detect_winner(brd)
end

player_win_count = 0
computer_win_count = 0

loop do # main loop
  board = initialize_board
  current_player = first_move

  loop do
    show_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  show_board(board)

  if someone_won?(board)
    puts
    puts "#{detect_winner(board)} won!"
  else
    puts
    puts "It's a tie!"
  end

  if detect_winner(board) == 'Player'
    player_win_count += 1
  elsif detect_winner(board) == 'Computer'
    computer_win_count += 1
  end

  puts "Player has #{player_win_count} wins."
  puts "Computer has #{computer_win_count} wins"
  puts

  break if player_win_count == 5 || computer_win_count == 5

  puts 'Type Y to play again , or anything else to quit.'
  play_again_answer = gets.chomp.downcase
  clear_screen
  break unless play_again_answer == 'y'
end

puts
puts 'Thanks for playing Tic Tac Toe v1.0.'
