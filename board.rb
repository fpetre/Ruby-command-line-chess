require_relative 'piece'
class Board
  SIZE = 8

  def self.create_board
    Array.new(SIZE){Array.new(SIZE)}
  end

  attr_reader :board, :size

  def initialize
    @board = Board.create_board
    @size = SIZE
    set_up_board
  end

  def set_up_board
    self.board[0].each_index do |index|
      self[[index, 0]] = Knight.new("black", [index, 0], self)
    end

    self.board[1].each_index do |index|
      self[[index, 1]] = Knight.new("black", [index, 1], self)
    end

    self.board[6].each_index do |index|
      self[[index, 6]] = Knight.new("white", [index, 6], self)
    end

    self.board[7].each_index do |index|
      self[[index, 7]] = Knight.new("white", [index, 7], self)
    end
  end

  def [](pos)
    x = pos[0]
    y = pos[1]
    @board[y][x]
  end

  def []=(pos, item)
    x = pos[0]
    y = pos[1]
    @board[y][x] = item
  end

  def inspect
    "..board.."
  end

end