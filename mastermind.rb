class Mastermind

  attr_reader :winning_pegs
  attr_accessor :unguessed_pegs

  def initialize(master = ComputerPlayer.new, guesser = HumanPlayer.new)
    @current_guess = []
    @master = master
    @guesser = guesser
    play_game
  end






  def one_round
    @current_guess = @guesser.input_guess
    @master.eval_guess(@current_guess)
  end

  def win?
    @winning_pegs == @current_guess
  end

  def play_game
    @winning_pegs = @master.start_pegs

    num_turns = 0
    until win? || num_turns == 10
      matches = one_round
      num_turns += 1

      puts "#{matches[0]} exact matches, #{matches[1]} near matches."
      puts "You have #{10 - num_turns} turns left"
    end
    if win?
      puts "You win!"
    else
      puts "You lose! The answer was: #{@winning_pegs}"
    end
  end

end

class HumanPlayer

  def start_pegs
    puts "Master, input your secret pegs"
    gets.chomp.upcase.split("")
  end

  def input_guess
    puts "Place your guess!"
    gets.chomp.upcase.split("")
  end
end

class ComputerPlayer

  def start_pegs
    @winning_pegs = Array.new(4){ %w{R G B Y O P}.sample }
  end

  def eval_guess(guess)
    @comp_unguessed_pegs = @winning_pegs.dup
    @player_unguessed_pegs = guess.dup

    [exact_matches(guess), near_matches(guess)]
  end

  private

  def exact_matches(guess)
    num_matches = 0

    4.times do |peg_index|
      if @winning_pegs[peg_index]==guess[peg_index]
        num_matches += 1
        @comp_unguessed_pegs[peg_index] = ""
        @player_unguessed_pegs[peg_index] = ""
      end
    end

    num_matches
  end

  def near_matches(guess)
    num_matches = 0
    4.times do |peg_index|
      curr_peg = guess[peg_index]
      if curr_peg != "" && @comp_unguessed_pegs.include?(curr_peg)
        num_matches += 1
        @comp_unguessed_pegs[@comp_unguessed_pegs.index(curr_peg)] = ""
      end
    end

    num_matches
  end

end

Mastermind.new
