class Piece

  attr_accessor :color, :pos, :board
  attr_reader :color_factor   # => make this private??

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @color_factor = self.color == "black" ? -1 : 1
  end

  def left(pos)
    [pos[0] - self.color_factor, pos[1]]
  end

  def right(pos)
    [pos[0] + self.color_factor, pos[1]]
  end

  def down(pos)
    [pos[0], pos[1] - self.color_factor]
  end

  def up(pos)
    [pos[0], pos[1] + self.color_factor]
  end

  def moves
    valid_moves = []
    self.deltas.select do |delta|
      new_pos =[]
      new_pos << delta[0] + self.pos[0]
      new_pos << delta[1] + self.pos[1]

      self.board[new_pos].nil? ||
      self.board[new_pos].color != self.color ||
      new_pos.all? { |coord| coord.between?(0,(self.board.size-1)) }
    end
  end
end

class SlidingPiece < Piece
  DIAGONAL_DELTAS = []
  ORTHOGONAL_DELTAS = []
end

class SteppingPiece < Piece

  def moves
    super
  end


  def deltas
    raise NotImplementedError
  end

end

class Knight < SteppingPiece

  def moves
    super
  end

  def deltas
    knight_delta = []

    knight_delta << up(left(left([0,0])))
    knight_delta << down(left(left([0,0])))
    knight_delta << up(right(right([0,0])))
    knight_delta << down(right(right([0,0])))
    knight_delta << up(up(left([0,0])))
    knight_delta << down(down(left([0,0])))
    knight_delta << up(up(right([0,0])))
    knight_delta << down(down(right([0,0])))

    knight_delta
  end




end