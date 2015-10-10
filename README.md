# wordbrain
Script that helps solve wordbrain puzzles

# To initialize
irb> require './wordbrain'
irb> wb = WordBrain.new

## Playing
letters are entered left to right, top to bottom from board
second parameter is the number of letters in the words

irb> wb.play(%w(t j u a s s i r g), [6, 3])


