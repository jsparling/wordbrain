require 'minitest/autorun'
require_relative 'wordbrain'
require 'debase'

class WordBrainTest < MiniTest::Test
  def setup
    @game = WordBrain.new
  end

  def test_initialization
    assert @game.words.count > 0
    assert @game.words["chair"]
    assert !@game.words["abcd"]
  end

  def test_find_words
    board = [%w(a m), %w(l a)]
    visited = [[false, false], [false, false]]
    expected = [["am", [[true, true], [false, false]]], ["aa", [[true, false], [false, true]]], ["al", [[true, false], [true, false]]]]
    words = @game.find_words([], board, visited, 0, 0, "", 2)
    assert_equal expected, words
  end

  def test_play_single_word
    board = [%w(a m), %w(l a)]
    expected = [["am", [[true, true], [false, false]]], ["aa", [[true, false], [false, true]]], ["al", [[true, false], [true, false]]], ["ma", [[false, true], [false, true]]], ["ma", [[true, true], [false, false]]], ["la", [[true, false], [true, false]]], ["la", [[false, false], [true, true]]], ["am", [[false, true], [false, true]]], ["al", [[false, false], [true, true]]]]
    words = @game.play_single_word(board, 2)
    assert_equal expected, words
  end

  def test_play
    board = [%w(o o t), %w(d a r), %w(d r c)]
    words = @game.play(board, [3, 6])
    expected_words = [["odd", "carrot"]]
    assert_equal expected_words, words
  end

  def test_play_4
    #[ c a ]
    #[ l m ]
    board = [%w(c a), %w(l m)]
    words_2 = @game.play(board, [2])
    words_4 = @game.play(board, [4])
    assert_equal [["am"], ["al"], ["la"], ["ma"]], words_2
    assert_equal [["calm"], ["clam"]], words_4
  end

  def test_play_2x2
    board = [%w(a m), %w(l a)]
    words = @game.play(board, [2, 2])
    assert words.include?(["am", "la"])
  end

  def test_play_7
    #[ c a ]
    #[ l m ]
    #[ i n ]
    #[ g x ]
    board = [%w(c a), %w(l m), %w(i n), %w(g x)]
    words = @game.play(board, [7])
    assert_equal [["calming"]], words
  end

  def test_fill_blank_array
    expected = [[false,false], [false, false], [false, false]]
    visited = @game.fill_blank_array(expected)
    assert_equal expected, visited
  end

  def test_reduce_board
    visited = [[true,false], [false, true], [false, false]]
    board = [%w(a b), %w(c d), %w(e f)]
    reduced_board = @game.reduce_board(board, visited)
    assert_equal [[nil, "b"], ["c", nil], %w(e f)], reduced_board
  end

  def test_shift_board_down
    board = [["x", "y"], [nil, "b"], ["c", nil], %w(e f)]
    shifted_board = @game.shift_board_down(board)
    assert_equal [[nil, nil], ["x", "y"], ["c", "b"], %w(e f)], shifted_board
  end

  def test_reduce_and_shift
    visited = [[false, false, false], [true, true, false], [true, false, true]]
    board = [%w(h s s ), %w(i s o), %w(f k c)]
    expected = [[nil, nil, nil], [nil, "s", "s"], ["h", "k", "o"]]
    temp_board = @game.reduce_board(board, visited)
    @game.shift_board_down(temp_board)
    actual = @game.reduce_and_shift_board(board, visited)
    assert_equal expected, actual
  end

  def test_simple_shift
    board = [["a"], [nil], [nil]]
    expected = [[nil], [nil], ["a"]]
    actual = @game.shift_board_down(board)
    assert_equal expected, actual
  end

  def test_board_with_nils
    board = [[nil, nil], [nil, "c"], %w(t a)]
    words_3 = @game.play(board, [3])
    assert_equal [["cat"], ["act"]], words_3
  end

  def test_convert_string_to_board
    string_array = %w(a b c d e f g h i)
    board = @game.convert_string_to_board(string_array)
    expected = [["a", "b", "c"], ["d", "e", "f"], ["g", "h", "i"]]
    assert_equal expected, board
  end

  def test_simple_string_input
    board = %w(h s s i s o f k c)
    words = @game.play(board, [4, 5])
    expected_words = [["fish", "socks"], ["fisc", "skosh"], ["cosh", "fisks"]]
    assert_equal expected_words, words
  end

  def test_multi_round
    board = [%w(h s s ), %w(i s o), %w(f k c)]
    words = @game.play(board, [4, 5])
    expected_words = [["fish", "socks"], ["fisc", "skosh"], ["cosh", "fisks"]]
    assert_equal expected_words, words

    board = [%w(o o t), %w(d a r), %w(d r c)]
    words = @game.play(board, [3, 6])
    expected_words = [["odd", "carrot"]]
    assert_equal expected_words, words

    board = [%w(l k s), %w(a o c), %w(t e p)]
    words = @game.play(board, [5, 4])
    expected_words = [["locks", "peat"], ["sceat", "polk"], ["talks", "cope"], ["tocks", "pela"], ["tocks", "peal"], ["polka", "tecs"], ["pokal", "tecs"], ["pocks", "late"], ["pocks", "teal"], ["peaks", "colt"], ["petal", "sock"]]
    assert_equal expected_words, words

    board = [%w(f y e), %w(s l l), %w(i c k)]
    words = @game.play(board, [3, 6])
    expected_words = ["fly", "sickle"]
    assert words.include?(expected_words)

    board = [%w(d n c), %w(t a a), %w(l e e)]
    words = @game.play(board, [3, 6])
    expected_words = ["eat", "candle"]
    assert words.include?(expected_words)
  end

  def test_3x3_3_words
    @game.words = { "sienh" => true, "shine" => true, "ma" => true, "xy" => true}
    board = %w(s i e h n m y x a)
    words = @game.play(board, [5, 2, 2])
  end

  def test_4x4_1
    board = %w(e n r d l o c o h b a t r t r e)
    converted_board = @game.convert_string_to_board(board)
    words = @game.play(converted_board, [5, 6, 5])
    expected = [["cable", "dorter", "north"], ["cable", "retrod", "north"], ["table", "record", "north"]]
    assert_equal expected, words
  end

  def test_4x4_2
    board = %w(d o o r r a p o a o b u l v c f)
    words = @game.play(board, [8,4,4])
    expected = [["cupboard", "roof", "oval"], ["cupboard", "roof", "vola"], ["cupboard", "oval", "roof"], ["cupboard", "vola", "roof"]]
    assert_equal expected, words
  end

  def test_4x4_3
    board = %w(b e s n a t e r r a n k r l l a)
    words = @game.play(board, [7,3,6])
    expected = [["stalker", "nan", "barrel"], ["stalker", "ann", "barrel"], ["tankers", "err", "ballan"], ["talkers", "nan", "barrel"], ["talkers", "ann", "barrel"], ["lantern", "ska", "barrel"], ["lantern", "kas", "barrel"], ["lantern", "ask", "barrel"]]
    assert_equal expected, words
  end
end
