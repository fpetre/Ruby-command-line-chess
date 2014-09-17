require_relative 'piece'

class InvalidMoveException < StandardError
end

class Board
  SIZE = 8
  PIECE_CLASS_ARR = [Rook,Knight,Bishop,Queen,King,Bishop,Knight,Rook]

  def self.create_board
    Array.new(SIZE){Array.new(SIZE)}
  end

  attr_reader :board, :size

  def initialize
    @board = Board.create_board
    @size = SIZE
    self.set_up_board
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
    puts "   " + ('a'..'h').to_a.join("  ")
    bstring = self.board.map.with_index do |row, row_num|
      "#{row_num + 1} " +
      row.map.with_index do |square,column_num|
        if square.nil?
           (column_num + row_num) % 2 == 0 ? "   ".colorize(:background =>:white ) : "   "
        else
           if (column_num + row_num) % 2 == 0
              square.print_piece.colorize(:background => :white)
           else
              square.print_piece
           end
        end
      end.join("") +
      " #{row_num + 1}"
    end.join("\n")
    puts bstring
    puts "   " + ('a'..'h').to_a.join("  ")
    nil
  end

  def move(color, start, end_pos)

    if self[start].nil?
      raise InvalidMoveException #"No piece at that position!"
    end

    if !self[start].moves.include?(end_pos)
      raise InvalidMoveException #"Cannot move piece to that position!"
    end

    if self[start].move_into_check?(end_pos)
      raise InvalidMoveException
    end

    if self[start].color != color
      raise InvalidMoveException
    end

    move!(start, end_pos)

    nil
  end

  def move!(start, end_pos)
    piece = self[start]
    piece.pos = end_pos
    self[start] = nil
    self[end_pos] = piece

    nil
  end

  def in_check?(color)
    other_color =  color == :white ? :black : :white
    find_all_color_moves(other_color).include?(find_king(color))
  end

  def checkmate?(color)
    return false unless self.in_check?(color)
    cannot_avoid_check?(color)
  end

  def stalemate?(color)
    return false if self.in_check?(color)
    cannot_avoid_check?(color)
  end

  def dup
    new_board = Board.new

    self.board.each_with_index do |row, y|
      row.each_with_index do |square, x|
        new_board[[x,y]] = square.nil? ? nil : square.dup(new_board)
      end
    end
    new_board
  end

  #protected

  def set_up_board
    # pawns
    self.board[0].each_index do |index|
      self[[index,1]] = Pawn.new(:black, [index,1], self)
    end

    self.board[1].each_index do |index|
      self[[index,6]] = Pawn.new(:white, [index,6], self)
    end
    #rest of pieces
    PIECE_CLASS_ARR.each_with_index do |piece_class,indx|
      self[[indx,7]] = piece_class.new(:white,[indx,7],self)
    end

    PIECE_CLASS_ARR.each_with_index do |piece_class,indx|
      self[[indx,0]] = piece_class.new(:black,[indx,0],self)
    end
  end

  def get_all_pieces
    self.board.flatten.compact
  end

  def cannot_avoid_check?(color)
    same_color_pieces = self.get_all_pieces.select {|piece| piece.color == color}

    same_color_pieces.all? do |piece|
      piece.moves.all? {|move| piece.move_into_check?(move)}
    end
  end

  def find_all_color_moves(color)
    same_color_pieces = self.get_all_pieces.select {|piece| piece.color == color}
    same_color_pieces.map(&:moves).flatten(1)
  end

  def find_king(color)
    same_color_pieces = self.get_all_pieces.select {|piece| piece.color == color}
    same_color_pieces.select { |piece| piece.is_a?(King) }.first.pos
  end

end

