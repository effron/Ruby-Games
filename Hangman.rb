class Hangman


  def initialize(guesser = HumanPlayer.new, master = ComputerPlayer.new)
    @guesser = guesser
    @master = master
  end

  def play
    @current_word = word_initializer
    turns = 0
    until win? || turns == 7

      old_word = @current_word

      guess = @guesser.make_guess(@current_word)

      matching = @master.reply_to_guess(guess)
      until legal_match?(matching)
        puts "I think you made a mistake, try again"
        matching = @master.reply_to_guess(guess)
      end

      @current_word = word_updater(@current_word,matching,guess)


      turns += 1 if old_word == @current_word
      puts "Turns left: #{7-turns}"
    end

    if win?
      puts "Congratulations! You guessed the word: #{@current_word}!"
    else
      puts "Guesser loses!"

      @guesser.respond_to_word(@master.reveal_word)
    end
  end


  private

  def legal_match?(indexes)
    indexes.each do |index|
      return false unless @current_word[index] == "_"
    end
    true
  end

  def win?
    !@current_word.include?("_")
  end

  def word_initializer
    "_" * @master.set_word
  end

  def word_updater(string, indexes, letter)

    temp = string.dup
    indexes.each do |match_index|
      temp[match_index]=letter
    end

    temp
  end


end



class ComputerPlayer

  def initialize(dictionary_file = "./dictionary.txt")
    @dictionary = create_dict_hash(dictionary_file)
    @guessed_letters = []
  end

  def set_word
     @word = @dictionary[rand(@dictionary.length)]
     @word.length
  end

  def reply_to_guess(letter)
    matched_indexes = []
    @word.length.times do |letter_index|
      matched_indexes << letter_index if @word[letter_index] == letter
    end
    matched_indexes
  end

  def reveal_word
    puts "Hey computer, what was the word?"
    puts "The word was #{@word}"
    @word
  end

  def respond_to_word(word)
    if @guess_dict.values.include?(word)
      puts "Computer Says: Well played"
    else
      puts "Computer Says: You cheated! That's not in the dictionary!"
    end
  end

  def make_guess(game_status)
    @guess_dict ||= init_guess_dict(game_status)

    regex = parse_game_status(game_status)

    prune_dict!(regex)
    p @guess_dict
    pick_letter
  end

  private

  def char_frequency
    letter_hash = Hash.new(0)

    @guess_dict.each do |key, word|
      word.each_char do |char|
        letter_hash[char] += 1 unless @guessed_letters.include?(char)
      end
    end

    return_array = letter_hash.sort_by { |key, value| value }
    p return_array
    return_array

  end

  def pick_letter
    return "You cheated" if char_frequency.empty?
    letter_picked = char_frequency.last[0]
    @guessed_letters << letter_picked
    letter_picked

  end

  def prune_dict!(game_status_regex)
    @guess_dict.select! do |key, word|
      game_status_regex.match(word)
    end

    correct_guesses = game_status_regex.inspect.split("")
    p correct_guesses
    wrong_guesses = @guessed_letters - correct_guesses
    p wrong_guesses
    unless wrong_guesses.empty?
      wrong_guesses.unshift("[")
      wrong_guesses.push("]")
      wg_string = wrong_guesses.join

      @guess_dict.reject! do |key, word|
        word.match(/#{wg_string}/)
      end
    end

  end

  def parse_game_status(game_status)
    Regexp.new game_status.gsub("_", ".")
  end

  def init_guess_dict(game_status)
    guess_dictionary = @dictionary.select do |key, word|
      word.length == game_status.length
    end
    guess_dictionary
  end

  def create_dict_hash(dictionary_file)
    dict_hash = {}
    dict_index = 0

    File.foreach(dictionary_file) do |word|
      unless word.include?("-") || word.length < 3
        dict_hash[dict_index] = word.chomp
        dict_index += 1
      end
    end
    dict_hash
  end

end




class HumanPlayer

  def set_word
    puts "How many letters does your word have?"
    gets.chomp.to_i
  end

  def make_guess(game_status)
    puts "Secret word: #{game_status}"
    letter = "invalid"

    until letter.length == 1
      puts "Enter a single letter guess"
      letter = gets.chomp
    end
    letter
  end

  def reply_to_guess(letter)
    puts "The guess is #{letter}"
    puts "Reply with a list of indexes, separated by commas"
    gets.chomp.split(",").map {|num| num.to_i}
  end

  def reveal_word
    puts "Master, what was the word?"
    word = gets.chomp
    puts "The word was #{word}"
    word
  end

  def respond_to_word(word)
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Hangman.new(guesser = ComputerPlayer.new, master =  HumanPlayer.new)
  # game = Hangman.new
  game.play
end