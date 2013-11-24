require 'Set'

class Hangman
  attr_accessor :guesser, :knower, :board

  def initialize
    @board = []
    @guesser = nil
    @knower = nil
  end

  def run

    got_players = false
    until (got_players == true)
      display_instructions
      got_players = assign_players
    end

    @board = @knower.determine_word
    draw_board

    until win?
      guess = @guesser.make_guess(@board)
      indices = @knower.check_guess(guess)
      insert_letters(guess, indices) if indices.length > 0
      draw_board
    end

    puts "Congratulations!"

  end

  def display_instructions
    puts "Welcome to Hangman!"
    puts "Would you like to be the guesser or the knower? (type 'guesser' or 'knower')"
    puts "Alternatively, type 'computer' to have a pure computer vs. computer game,"
    puts "Or type 'human' to have a pure human vs. human game."
  end

  def assign_players
    role = gets.downcase.chomp

    case role
    when "guesser"
      @guesser = HumanPlayer.new
      @knower = ComputerPlayer.new
    when "knower"
      @guesser = ComputerPlayer.new
      @knower = HumanPlayer.new
    when "computer"
      @guesser = ComputerPlayer.new
      @knower = ComputerPlayer.new
    when "human"
      @guesser = HumanPlayer.new
      @knower = HumanPlayer.new
    else
      puts "Invalid input. Exiting."
      return false
    end
    true
  end

  def draw_board
    puts @board.join(" ")
  end

  def win?
    !@board.include?("_")
  end

  def insert_letters(letter, indices)
    indices.each { |index| @board[index] = letter }
  end

end

class ComputerPlayer
  attr_accessor :dictionary, :secret_word, :letter_array, :used_letters

  def initialize
    @dictionary = []
    File.readlines('./dictionary.txt').each { |line| @dictionary << line.chomp }

    @secret_word = ''
    @secret_word_length = 0

    @letter_array = []
    @used_letters = []
  end

  def determine_word
    until @secret_word.match(/^(\w)+$/)
      @secret_word = @dictionary.sample
    end
    
    Array.new(@secret_word.length) { "_" }
  end

  def make_guess(board)
    word_array = make_word_array(board)
    @letter_array = make_letter_array(word_array)
    guess = @letter_array.pop
    
    print  "Computer guesses #{guess.upcase}: "
    
    used_letters << guess
    guess
  end

  def make_word_array(board)
    regexp = "^#{board.join.gsub(/_/,'\w')}$"

    possible_words = []

    @dictionary.each do |word|
      possible_words << word if word.match(regexp)
    end

    possible_words
  end

  def make_letter_array(arr)
    letter_pool = arr.join.split('')
    letter_counts = Hash.new(0)
    pairs_array = []
    return_arr = []

    letter_pool.each do |letter|
      letter_counts[letter] += 1
    end

    letter_counts.each_pair do |key, value|
      pairs_array << [value, key]
    end

    pairs_array.sort!.each do |pair|
      return_arr << pair[1]
    end

    return_arr -= @used_letters
    #p letter_counts
    #p @letter_array
    return return_arr -= @used_letters
  end

  def check_guess(letter)
    response_array = []
    @secret_word.split('').each_index { |index| response_array << index if @secret_word[index] == letter }
    response_array
  end
end

class HumanPlayer

  def determine_word
    puts "KNOWING PLAYER: How long is the word (in characters)?"
    length = Integer(gets.chomp)
    Array.new(length) { "_" }
  end

  def make_guess(board)
    puts "GUESSING PLAYER: Please enter a letter:"
    gets.chomp
  end

  def check_guess(letter)
    puts "KNOWING PLAYER: Enter the indices (starting from 0) where the letter resides in your word."
    puts "Multiple places can be separated by a space (ex. 0 5)."
    puts "Enter 'none' if letter is not present."

    response = gets.chomp
    return [] if response == "none"

    response_array = []
    response.split(" ").each { |index| response_array << Integer(index) }
    response_array
  end

end

h = Hangman.new
h.run
