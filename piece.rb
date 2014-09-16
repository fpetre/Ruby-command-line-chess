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



end

class SlidingPiece

end

class SteppingPiece

end

class Knight



  def moves

  end

  def all_knight_moves
    all_knight_moves = []

    all_knight_moves << up(left(left(pos)))
    all_knight_moves << down(left(left(pos)))
    all_knight_moves << up(right(right(pos)))
    all_knight_moves << down(right(right(pos)))
    all_knight_moves << up(up(left(pos)))
    all_knight_moves << down(down(left(pos)))
    all_knight_moves << up(up(right(pos)))
    all_knight_moves << down(down(right(pos)))

    all_knight_moves
  end




end