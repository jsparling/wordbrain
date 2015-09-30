require 'minitest/autorun'
require_relative 'wordbrain'
require 'debase'

class WordBrainTest < MiniTest::Test
  def setup
    @game = WordBrain.new
    @board = [%w(c a), %w(l m), %w(i n)]
    @game.board = @board
  end

  def test_initialization
    assert @game.words.count > 0
    assert @game.words["chair"]
    assert !@game.words["abcd"]

    assert @game.board
    assert_equal 'c', @game.board[0][0]
    assert_equal 'a', @game.board[0][1]
    assert_equal 'l', @game.board[1][0]
    assert_equal 'm', @game.board[1][1]

    assert_equal 2, @game.num_cols
    assert_equal 3, @game.num_rows
  end

  def test_play_4
    #[ c a ]
    #[ l m ]
    @game = WordBrain.new
    @game.board = [%w(c a), %w(l m)]
    @game.print_board
    words_4 = @game.play(@game.board, 4)
    words_2 = @game.play(@game.board, 2)
    @game.print_word_list
    assert_equal ["calm", "clam"], words_4
    assert_equal ["am", "al", "la", "ma"], words_2
  end

  def test_play_6
    #[ c a ]
    #[ l m ]
    #[ i n ]
    #[ g x ]
    @game = WordBrain.new
    @game.board = [%w(c a), %w(l m), %w(i n), %w(g x)]
    @game.print_board
    words = @game.play(@game.board, 7)
    @game.print_word_list
    assert_equal ["calming"], words
  end


  def test_fill_blank_array
    visited = @game.fill_blank_array
    expected = [[false,false], [false, false], [false, false]]
    assert_equal expected, visited
  end

  def test_create_word_lists
    raw_words = @game.word_list
    numbered_word_list = @game.create_word_lists(raw_words)
    assert numbered_word_list[4]["calm"]
    assert numbered_word_list[6]["shield"]
  end
end
