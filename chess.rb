#!/usr/bin/env ruby

require_relative 'board'
require 'yaml'
require 'colorize'

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
      puts "\e[H\e[2J"
      self.board.render
      print "#{self.current_player[1].to_s}'s turn.  "
      begin
        move = self.current_player[0].play_turn

        if move == "save"
          self.save_game
          redo
        end

        translated_move = translate_move(move)

        self.board.move(self.current_player[1], translated_move[0], translated_move[1])
        self.current_player[1] = self.current_player[1] == :black ? :white : :black

      rescue InvalidMoveException
        puts "invalid move!"
        retry
      end
    end

    puts "\e[H\e[2J"
    self.board.render

    if self.winner
      puts "Game over. #{self.winner} won!"
    else
      puts "Game over. Stalemate."
    end
  end

  #protected

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
      self.winner = self.current_player[1] == :white ? "black" : "white"
      return true
    elsif self.board.stalemate?(self.current_player[1])
      return true
    end

    false
  end

  def save_game
    puts "please enter file name"
    file_name = gets.chomp
    File.write(file_name, YAML.dump(self))
  end
end


class HumanPlayer

  def play_turn
    begin
      puts "Please enter move (e.g. f3,f4)"
      move = gets.chomp

      unless move[/^[a-h][1-8][,][a-h][1-8]$/] || move == "save"
        raise InvalidEntryException
      end
    rescue InvalidEntryException
      puts "invalid move"
      retry
    end

    move
  end

end


if __FILE__ == $PROGRAM_NAME

  case ARGV.count
  when 0
    h1 = HumanPlayer.new
    h2 = HumanPlayer.new
    g = Game.new(h1,h2)
  when 1
    g = YAML.load_file(ARGV.shift)
  end

  g.play
end