class TicTacToe
  def initialize
    @cpu = "X"
    @player = "O"

    @board = { "c1" => " ", "e1" => " ", "c2" => " ",
               "e2" => " ", "ct" => " ", "e3" => " ",
               "c3" => " ", "e4" => " ", "c4" => " " }

    @positions = @board.keys

    @board_guide = " c1 | e1 | c2 \n-------------\n e2 | ct | e3 \n-------------\n c3 | e4 | c4"

    @winning_combos = [["c1", "e1", "c2"], ["e2", "ct", "e3"], ["c3", "e4", "c4"], ["c1", "e2", "c3"], ["e1", "ct", "e4"], ["c2", "e3", "c4"], ["c3", "ct", "c2"], ["c1", "ct", "c4"]]

    instructions
    cpu_game_start

  end

  def print_board
    puts ""
    puts " #{@board["c1"]} | #{@board["e1"]} | #{@board["c2"]} \n-----------\n #{@board["e2"]} | #{@board["ct"]} | #{@board["e3"]} \n-----------\n #{@board["c3"]} | #{@board["e4"]} | #{@board["c4"]} "
    puts ""
  end

  def cpu_game_start
    moves = @positions.reject { |p| p.include?("e") } # Rejecting possible edge start positions. Corner start is strategically best and help prevents forking win by player.
    randomize_game_start = moves.sample
    @board[randomize_game_start] = @cpu
    print_board
  end

  def instructions
    puts "Play Tic-Tac-Toe!"
    puts ""
    puts "Try to beat the CPU player. CPU plays X and you will play O."
    puts 'When it is your turn, input the position you would like to play your "O" token. The board positions are:'
    puts ""
    puts @board_guide
    puts ""
    puts 'For your reference, "c" stands for corner, "e" stands for edge, and "ct" stands for center.'
    puts 'You can enter "help" when it is your turn to reprint the board positions guide.'
    puts 'Also, entering "board" will reprint the current board and entering "end" will end the game.'
    puts ""
  end

  # Logic for player turn.
  def player_turn
    puts 'Where do you want to place "O"?'
    player_input = gets.chomp.downcase

    if player_input == "help"
      help
    elsif player_input == "board"
      player_request_board
    elsif player_input == "end"
      end_game
    elsif @positions.include?(player_input)

      if @board[player_input] == " "
        @board[player_input] = @player
        puts "Player moves to #{player_input}."
        puts ""
        print_board
      else
        already_played
      end

    else
      invalid_play
    end
  end

  # Various responses to player input
  def help
    puts @board_guide
    player_turn
  end

  def player_request_board
    print_board
    player_turn
  end

  def already_played
    puts "You cannot pick a position already in play."
    player_turn
  end

  def invalid_play
    puts "Please input a valid board position."
    player_turn
  end

  def end_game
    @end_game = true
  end

  # Counts the tokens in all of the possible winning combinations.
  def check_winning_combos(combo, token)
    count = 0
    combo.each do |item|
      if @board[item] == token
        count += 1
      end
    end
    count
  end

  # CPU picks a random move if no other strategically better options are available.
  def pick_random_move
    randomize = @positions.sample
    if @board[randomize] == " "
      randomize
    else
      pick_random_move
    end
  end

  def cpu_turn
    moves = {'wins' => [], 'plays' => []}
    @winning_combos.each do |combo|
      # Select the empty spot to play
      if check_winning_combos(combo, @cpu) == 2
        moves['wins'].concat combo.select { |c| @board[c] == " " }.first(1)
      elsif check_winning_combos(combo, @player) == 2
        moves['plays'].concat combo.select { |c| @board[c] == " " }.first(1)
      end

    end

    if !moves['wins'].empty? # Play winning combination if possible.
      puts "CPU plays at #{moves['wins'].first}"
      @board[moves['wins'].first] = @cpu

    elsif !moves['plays'].empty? # Block the player if they have two in a winning combination.
      puts "CPU plays at #{moves['plays'].first}"
      @board[moves['plays'].first] = @cpu

    elsif @board["ct"] == " " # If center position has not been played by CPU, then play it to completely stop any possible player wins by forking.
      @board["ct"] = @cpu

    else
      move = pick_random_move # CPU randomly moves if other strategically better options are not available.
      puts "CPU plays at #{move}"
      @board[move] = @cpu
    end

    print_board

  end

  # Game play order
  def play
    if @end_game
      puts "Goodbye!"
    else
      player_turn
      cpu_turn
      cpu_win?
    end
  end

  # Check to see if it is a win by CPU.
  def cpu_win?
    @winning_combos.each do |combo|
      if check_winning_combos(combo, @cpu) == 3
        puts "The CPU has beaten you at Tic-Tac-Toe! Game Over!"
        return true
      end
    end
    any_moves_left?
  end

  # Check to see if it is a draw.
  def any_moves_left?
    unplayed = 0
    @positions.each do |p|
      if @board[p] == " "
        unplayed += 1
      end
    end
    if unplayed == 0
      puts "It's a draw!"
    else
      play
    end
  end

end

game = TicTacToe.new

game.play
