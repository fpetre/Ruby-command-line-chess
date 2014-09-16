require_relative 'board'

class Piece

  attr_accessor :color, :pos, :board
  attr_reader :color_factor   # => make this private??

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @color_factor = self.color == "black" ? 1 : -1
  end

  def left(pos)
    [pos[0] + self.color_factor, pos[1]]
  end

  def right(pos)
    [pos[0] - self.color_factor, pos[1]]
  end

  def down(pos)
    [pos[0], pos[1] + self.color_factor]
  end

  def up(pos)
    [pos[0], pos[1] - self.color_factor]
  end

  def moves
  end

  def can_move?(pos)
    return false unless pos.all? do |coord|
      coord.between?(0,(self.board.size-1))
    end

    self.board[pos].nil? ||
    self.board[pos].color != self.color
  end
end


class SlidingPiece < Piece
  # DIAGONAL_DELTAS = []
  # ORTHOGONAL_DELTAS =[]

  def moves
    valid_moves = []

    self.delta_directions.each do |delta|
      new_pos =[]
      new_pos << delta[0] + self.pos[0]
      new_pos << delta[1] + self.pos[1]
      while can_move?(new_pos)
        p "loop new pos: #{new_pos}"
        valid_moves << new_pos.dup
        new_pos[0] = delta[0] + new_pos[0]
        new_pos[1] = delta[1] + new_pos[1]

        if !self.board[new_pos].nil? &&
           self.board[new_pos].color != self.color
          valid_moves << new_pos.dup
          break
        end
      end
    end
    valid_moves
  end

end

class Bishop < SlidingPiece
  def delta_directions
    delta_directions = []
    delta_directions << right(up([0,0]))
    delta_directions << left(up([0,0]))
    delta_directions << right(down([0,0]))
    delta_directions << left(down([0,0]))

    delta_directions
  end

end

class Queen < SlidingPiece
  def delta_directions
    delta_directions = []
    delta_directions << right(up([0,0]))
    delta_directions << left(up([0,0]))
    delta_directions << right(down([0,0]))
    delta_directions << left(down([0,0]))
    delta_directions << up([0,0])
    delta_directions << left([0,0])
    delta_directions << right([0,0])
    delta_directions << down([0,0])


    delta_directions
  end
end

class Rook < SlidingPiece
  def delta_directions
    delta_directions = []
    delta_directions << up([0,0])
    delta_directions << left([0,0])
    delta_directions << right([0,0])
    delta_directions << down([0,0])

    delta_directions
  end

end



class SteppingPiece < Piece

  def moves
    valid_moves = []
    self.deltas.each do |delta|
      new_pos =[]
      new_pos << delta[0] + self.pos[0]
      new_pos << delta[1] + self.pos[1]
      valid_moves << new_pos if can_move?(new_pos)
    end
    valid_moves
  end

  def deltas
    raise NotImplementedError
  end

end


class King < SteppingPiece

  def moves
    super
  end

  def deltas
    king_delta = []
    king_delta << up([0,0])
    king_delta << down([0,0])
    king_delta << left([0,0])
    king_delta << right([0,0])
    king_delta << right(up([0,0]))
    king_delta << left(up([0,0]))
    king_delta << right(down([0,0]))
    king_delta << left(down([0,0]))

    king_delta
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