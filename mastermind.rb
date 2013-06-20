class Mastermind

  attr_reader :winning_pegs
  attr_accessor :unguessed_pegs

  def initialize
    @current_guess = []
    play_game
  end

  def start_pegs
    @winning_pegs = Array.new(4){ %w{R G B Y O P}.sample }
  end

  def input_guess
    puts "Place your guess!"
    @current_guess = gets.chomp.upcase.split("")
    @comp_unguessed_pegs = @winning_pegs.dup
    @player_unguessed_pegs = @current_guess.dup
  end

  def exact_matches
    num_matches = 0

    4.times do |peg_index|
      if @winning_pegs[peg_index]==@current_guess[peg_index]
        num_matches += 1
        @comp_unguessed_pegs[peg_index] = ""
        @player_unguessed_pegs[peg_index] = ""
      end
    end

    num_matches
  end

  def near_matches
    num_matches = 0
    4.times do |peg_index|
      curr_peg = @current_guess[peg_index]
      if curr_peg != "" && @comp_unguessed_pegs.include?(curr_peg)
        num_matches += 1
        @comp_unguessed_pegs[@comp_unguessed_pegs.index(curr_peg)] = ""
      end
    end

    num_matches
  end

  def one_round
    input_guess
    [exact_matches, near_matches]
  end

  def win?
    @winning_pegs == @current_guess
  end

  def play_game
    answer = start_pegs

    num_turns = 0
    until win? || num_turns ==10
      matches = one_round
      num_turns += 1

      puts "#{matches[0]} exact matches, #{matches[1]} near matches."
      puts "You have #{10 - num_turns} turns left"
    end
    if win?
      puts "You win!"
    else
      puts "You lose! The answer was: #{answer}"
    end
  end

end

Mastermind.new
