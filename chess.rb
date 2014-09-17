require_relative 'board'

class InvalidEntryException < StandardError
end

class Game

  attr_reader :current_player

  def initialize(player1, player2)
    @white = player1
    @black = player2
    @board = Board.new
    @current_player = @white
  end

  def play
    until self.won?
      begin
        move = translate_move(self.current_player.play_turn)
        self.board.move(move)
      rescue
        puts "invalid move!"
        retry
      end
    end
  end

  def translate_move(moves)
    move_arr = moves.downcase.split(",")
    move_arr.map do |move|
      x = ("a".."h").to_a.index(move[0])
      y = (move[1].to_i - 1)
      [x, y]
    end
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