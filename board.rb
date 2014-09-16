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

    # pawns
    self.board[0].each_index do |index|
      self[[index,1]] = Pawn.new("black", [index,0], self)
    end

    self.board[1].each_index do |index|
      self[[index,6]] = Pawn.new("white", [index,1], self)
    end

    # Rooks
    self[[0,0]] = Rook.new("black", [0,0], self)
    self[[7,0]] = Rook.new("black", [7,0], self)

    self[[0,7]] = Rook.new("white", [0,7], self)
    self[[7,7]] = Rook.new("white", [7,7], self)

    # Knights
    self[[1,0]] = Knight.new("black", [1,0], self)
    self[[6,0]] = Knight.new("black", [6,0], self)

    self[[1,7]] = Knight.new("white", [1,7], self)
    self[[6,7]] = Knight.new("white", [6,7], self)

    # Bishops
    self[[2,0]] = Bishop.new("black", [2,0], self)
    self[[5,0]] = Bishop.new("black", [5,0], self)

    self[[2,7]] = Bishop.new("white", [2,7], self)
    self[[5,7]] = Bishop.new("white", [5,7], self)

    # Queens
    self[[3,0]] = Queen.new("black", [3,0], self)

    self[[3,7]] = Queen.new("white", [3,7], self)

    # Kings
    self[[4,0]] = King.new("black", [4,0], self)

    self[[4,7]] = King.new("white", [4,7], self)

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

  def render
   bstring = self.board.map do |row|
      row.map do |square|
        square.nil? ? "_" : square.print_piece
      end.join(" ")
    end.join("\n")
    puts bstring
    nil
  end

  def find_king(color)
    self.board.each_with_index do |row, y|
      row.each_with_index do |square, x|
       return [x,y] if square.is_a?(King) && square.color == color
      end
    end
  end
end