require_relative 'board'

class InvalidEntryException < StandardError
end

class Game

  attr_reader :current_player, :board
  attr_accessor :winner

  def initialize(player1, player2)
    @white = player1
    @black = player2
    @board = Board.new
    @current_player = [@white, :white]
    @winner = nil
  end

  def play
    until self.game_over?
      self.board.render
      print "#{self.current_player[1].to_s}'s turn.  "
      begin
        move = translate_move(self.current_player[0].play_turn)
        p move

        if wrong_color?(self.current_player[1], move[0])
          raise InvalidMoveException
        end

        self.board.move(move[0], move[1])
        self.current_player[1] = self.current_player[1] == :black ? :white : :black
        self.board[move[1]].has_moved = true
      rescue InvalidMoveException
        puts "invalid move!"
        retry
      end
    end

    if self.winner
      puts "Game over. #{self.winner} won!"
    else
      puts "Game over. Stalemate."
    end
  end

  def wrong_color?(color, pos)
    color != self.board[pos].color
  end

  def translate_move(moves)
    move_arr = moves.downcase.split(",")
    move_arr.map do |move|
      x = ("a".."h").to_a.index(move[0])
      y = (move[1].to_i - 1)
      [x, y]
    end
  end

  def game_over?
    if self.board.checkmate?(self.current_player[1])
      winner = self.current_player[1].to_s
      return true
    elsif self.board.stalemate?(self.current_player[1])
      return true
    end

    false
  end

end


class HumanPlayer

  def play_turn

    begin
      puts "Please enter move (e.g. f3,f4)"
      move = gets.chomp
      unless move[/^[a-h][1-8][,][a-h][1-8]$/]
        raise InvalidEntryException
      end
    rescue
      puts "invalid move"
      retry
    end

    move
  end

end