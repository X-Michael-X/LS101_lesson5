require 'pry'

INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze

puts 'Welcome to Tic Tac Toe v1.0'
puts ' '
puts 'The object of Tic Tac Toe is to get three in a row. You play on a three' \
     'by three game board. The first player is known as X and the computer' \
     'is O. Players alternate placing Xs and Os on the game board until' \
     'either opponent has three in a row or all nine squares are filled.'
puts ' '

def show_board(brd)
  system 'cls'
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

def player_move!(brd)
  choice = ''
  loop do
    puts "Choose a square (#{empty_squares(brd).join(', ')})"
    choice = gets.chomp.to_i
    break if empty_squares(brd).include?(choice)
    puts 'Sorry your choice was invalid. Please choose again'
  end
  brd[choice] = PLAYER_MARKER
end

def computer_move!(brd)
  choice = empty_squares(brd).sample
  brd[choice] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def detect_winner(brd)
  winning_lines = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  winning_lines.each do |line|
    if brd[line[0]] == PLAYER_MARKER &&
       brd[line[1]] == PLAYER_MARKER &&
       brd[line[2]] == PLAYER_MARKER
      return 'Player'
    elsif brd[line[0]] == COMPUTER_MARKER &&
          brd[line[1]] == COMPUTER_MARKER &&
          brd[line[2]] == COMPUTER_MARKER
      return 'Computer'
    end
  end
  nil
end

def someone_won?(brd)
  !!detect_winner(brd)
end

loop do
  board = initialize_board

  loop do
    show_board(board)
    player_move!(board)
    break if board_full?(board) || someone_won?(board)
    computer_move!(board)
    break if board_full?(board) || someone_won?(board)
  end

  show_board(board)

  if someone_won?(board)
    puts "#{detect_winner(board)} won!"
  else
    puts "It's a tie!"
  end

  puts 'Would you like to play again? (Y or N)?'
  play_again_answer = gets.chomp.downcase
  break unless play_again_answer.start_with?('y')
end

puts ' '
puts 'Thanks for playing Tic Tac Toe v1.0.'

