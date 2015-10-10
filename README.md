# wordbrain
Script that helps solve wordbrain puzzles

# To Play

```ruby
irb> require './wordbrain'
irb> wb = WordBrain.new
```

letters are entered left to right, top to bottom from board
second parameter is the number of letters in the words

```ruby
irb> wb.play(%w(t j u a s s i r g), [6, 3])
=> [["stairs", "jug"], ["stairs", "gju"]]
```

each potential set of words is contained in "[...]"

# Possible words
Word dictionary is from https://github.com/atebits/Words

