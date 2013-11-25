require 'Set'

class WordPath
  attr_accessor :start_word, :stop_word, :candidate_words

  def initialize
    @start_word, @stop_word = '', ''

    @words_to_expand = Set.new 
    @candidate_words = Set.new
    @all_reachable_words = Set.new

    @parents = {}

  end

  def run

    puts "Welcome to Word Path!  Please enter start word:"
    @start_word = gets.chomp
    @words_to_expand.add(@start_word)
    @all_reachable_words.add(@start_word)

    puts "Please enter stop word:"
    @stop_word = gets.chomp

    puts "start = #{start_word}, stop = #{stop_word}"
    dict = make_dictionary
    find_chain(@start_word, @stop_word, dict)
    puts build_path_from_breadcrumbs
  end

  def adjacent_words(word, dictionary)
    dictionary.select { |candidate| word.length == candidate.length && 
                                    one_letter_different?(word, candidate) }
  end

  def one_letter_different?(word1, word2)
    arr1 = word1.split('')
    arr2 = word2.split('')
    different_letter = 0

    arr1.each_index do |index|
      different_letter += 1 if arr1[index] != arr2[index]
    end

    different_letter == 1
  end

  def make_dictionary
    File.readlines('./dictionary.txt').map(&:chomp)
  end

  def explore_words(start_word, dictionary)
    @candidate_words = adjacent_words(start_word, dictionary)
    words_expanded = Set.new

    while @words_to_expand.length > 0
      word = @words_to_expand.first
      @words_to_expand.delete(word)
      words_expanded.add(word)
     
      adjacent_words(word, dictionary).each do |candidate|
        @candidate_words.delete(candidate)
        @words_to_expand.add(candidate) unless words_expanded.include?(candidate)
        @all_reachable_words.add(candidate)
      end
    end

    @all_reachable_words
  end

  def find_chain(start_word, stop_word, dictionary)
    @candidate_words = adjacent_words(start_word, dictionary)
    words_expanded = Set.new

    while @words_to_expand.length > 0
      word = @words_to_expand.first
      #puts word
      @words_to_expand.delete(word)
      words_expanded.add(word)

      adjacent_words(word, dictionary).each do |candidate|
        @candidate_words.delete(candidate)
        @words_to_expand.add(candidate) unless words_expanded.include?(candidate)
        @parents[candidate] = word unless words_expanded.include?(candidate)
        return @parents if candidate == stop_word
      end
    end
    @parents
  end

  def build_path_from_breadcrumbs
    path_array = [stop_word]

    parent = @parents[@stop_word]
    path_array << parent

    until parent == start_word
      grand_parent = @parents[parent]
      path_array << grand_parent
      parent = grand_parent
    end
    path_array.reverse
  end

end

wp = WordPath.new
wp.run