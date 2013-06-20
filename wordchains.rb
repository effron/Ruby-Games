require 'set'
require 'benchmark'
class WordChains

  def initialize(start_word, end_word, dictionary = "./dictionary.txt")
    @start_word = start_word
    @end_word = end_word
    @dictionary = dict_loader(dictionary)
  end

  def adjacent_words(word)

    near_words = []

    word.length.times do |index|
      # p "#{word[0...index]}"
      # p "#{word[(index+1)..-1]}"
      near_words += @dictionary.select do |valid_word|

        valid_word =~ /#{word[0...index]}[a-z]#{word[(index+1)..-1]}/ &&
        valid_word != word
      end
    end

    near_words.uniq
  end

  def find_chain
    dict = @dictionary

    current_words = [@start_word]
    new_words = []
    visited_words = {@start_word => nil}

    new_words += adjacent_words(@start_word)
    new_words -= current_words

    new_words.each do |word|
      visited_words[word] = current_words[-1] unless visited_words.include?(word)
    end

    #if not in one move, loop until found
    until new_words.include?(@end_word)
       #p "entering until loop"
      current_words = new_words.dup
      new_words = []

      #debugging
     # p current_words
      # finding_count = 0
     # p current_words.length

      current_words.each do |current_word|
        #debugging
        # p "finding adjacent words"
  #       p finding_count
  #       finding_count +=1

        adj = adjacent_words(current_word)
        new_words += adj

        adj.each do |word|
          unless visited_words.include?(word)
            visited_words[word] = current_word
          end
        end
        new_words -= current_words
      end
    end

   # p visited_words #debugging

    return build_chain(visited_words,@end_word)

  end

  def build_chain(visited_words, word)
    #p "entering build_chain"
    chain = [word]
    lookup = word

    until lookup == nil
      chain << visited_words[lookup] unless visited_words[lookup]==nil
      lookup = visited_words[lookup]
      #p lookup
    end

    chain
  end

  def dict_loader(dictionary)
    dict_set = Set.new
    File.foreach(dictionary) do |word|

      dict_set << word.chomp if word.chomp =~ /^\w{7}$/i

    end
    dict_set
  end
end

word_chain = WordChains.new("duck","ruby")

p Benchmark.measure { word_chain.find_chain }
#p Benchmark.measure { word_chain.adjacent_words("shopper") }


