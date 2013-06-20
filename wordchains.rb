def adjacent_words(word, dictionary)
  dict = dict_loader(dictionary)
  near_words = []
  
  word.length.times do |index|
    near_words += dict.select do |valid_word|
      valid_word.length == word.length && 
      valid_word =~ /#{word[0...index]}[a-z]#{word[(index+1)..-1]}/ &&
      valid_word != word
      
    end
  end
  near_words.uniq
end

def find_chain(start_word, end_word, dictionary)
  dict = dict_loader(dictionary)
  
  current_words = [start_word]
  new_words = []
  visited_words = {start_word => nil}
  
  new_words += adjacent_words(start_word,dictionary)
  new_words -= current_words
  
  new_words.each do |word|
    visited_words[word] = current_words[-1] unless visited_words.include?(word)
  end
  
  #if not in one move, loop until found
  until new_words.include?(end_word)
    # p "entering until loop"
    current_words = new_words.dup.uniq
    new_words = []
    
    #debugging
    # p current_words
 #    finding_count = 0
 #    p current_words.length
    
    current_words.each do |current_word|
      #debugging
      # p "finding adjacent words"
#       p finding_count
#       finding_count +=1
      
      adj = adjacent_words(current_word,dictionary)
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
  
  return build_chain(visited_words,end_word)
  
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
  File.readlines(dictionary).map{|word| word.chomp}
end

p find_chain("shopper","clipper","dictionary.txt")
