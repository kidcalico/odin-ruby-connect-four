require_relative '../main'

describe Board do
  subject(:board) { described_class.new }

  describe '#build_row' do
    it 'will return an array of black circles on a blue background' do
      row = board.build_row
      expected_array = ["\e[0;44m \e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m \e[0m\n"]
      expect(row).to eq(expected_array)
    end
  end

  describe '#build_board' do
    it 'will return a nested array of black circles with blue backgrounds' do
      board_array = board.build_board
      expected_array = [["\e[0;44m                \e[0m\n"], ["\e[0;44m \e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m \e[0m\n"], ["\e[0;44m \e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m \e[0m\n"], ["\e[0;44m \e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m \e[0m\n"], ["\e[0;44m \e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m \e[0m\n"], ["\e[0;44m \e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m \e[0m\n"], ["\e[0;44m \e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m⚫\e[0m", "\e[0;44m \e[0m\n"], ["\e[0;44m 1 2 3 4 5 6 7  \e[0m\n"]]
      expect(board_array).to eq(expected_array)
    end
  end
end

describe Play do
  subject(:game) { described_class.new }

  let(:yellow_circle) { "\e[0;44m\u{1F7E1}\e[0m" }
  let(:red_circle) { "\e[0;44m\u{1F534}\e[0m" }

  describe '#get_input' do
    context 'when user input is valid' do
      before do
        int = '5'
        allow(game).to receive(:gets).and_return(int)
      end

      it 'returns a valid integer' do
        player_move = game.get_input
        expect(player_move).to eq(5)
      end
    end

    context 'when first input is invalid and second input is valid' do
      before do
        string = 'hello'
        int = '7'
        allow(game).to receive(:gets).and_return(string, int)
      end

      it 'completes loop and displays error message once' do
        expect(game).to receive(:puts).with('Please enter a number between 1 and 7!').once
        game.get_input
      end
    end
  end

  describe '#move' do
    context 'when it is yellow\'s turn and the bottom row of chosen column is empty' do
      let(:move) { 3 }

      before do
        game.move('yellow', move)
      end
      
      it 'replaces black circle with yellow circle' do
        result = game.board_array[6][move]
        expect(result).to eq(yellow_circle)
      end
    end

    context 'when it is red\'s turn and the bottom row of chosen column is not empty' do
      let(:move) { 3 }

      before do
        game.board_array[6][move] = yellow_circle
        game.move('red', move)
      end

      it 'replaces the lowest black circle with a red circle' do
        result = game.board_array[5][move]
        expect(result).to eq(red_circle)
      end
    end
  end

  describe '#column_win?' do
    context 'when last move does not create a winning column' do
      let(:move) { 2 }

      before do
        game.board_array[6][2] = red_circle
        game.board_array[5][2] = yellow_circle
        game.board_array[4][2] = red_circle
      end
      
      it 'returns nil' do
        piece = red_circle
        last_row = 3
        expect(game.column_win?(last_row, move, piece)).to be nil
      end
    end
    
    context 'when last move creates a winning column' do
      let(:move) { 2 }
      
      before do
        game.board_array[6][2] = red_circle
        game.board_array[5][2] = red_circle
        game.board_array[4][2] = red_circle
      end
      
      it 'returns true' do
        piece = red_circle
        last_row = 3
        result = game.column_win?(last_row, move, piece)
        expect(result).to be true
      end
    end
  end
  
  describe '#row_win?' do
    context 'when last move does not create a winning row' do
      let(:move) { 5 }
    
      before do
        game.board_array[6][3] = yellow_circle
        game.board_array[6][4] = red_circle
        game.board_array[6][6] = yellow_circle
      end

      it 'returns nil' do
        piece = yellow_circle
        last_row = 6
        result = game.row_win?(last_row, move, piece)
        expect(result).to be nil
      end
    end

    context 'when last move creates a winning row' do
      let(:move) { 5 }
    
      before do
        game.board_array[6][3] = yellow_circle
        game.board_array[6][4] = yellow_circle
        game.board_array[6][6] = yellow_circle
      end

      it 'returns true' do
        piece = yellow_circle
        last_row = 6
        result = game.row_win?(last_row, move, piece)
        expect(result).to be true
      end
    end
  end

  describe '#diagonal_win?' do
    let(:move) { 1 }
    context 'when last move creates a diagonal win' do
      before do
        game.board_array[5][2] = red_circle
        game.board_array[4][3] = red_circle
        game.board_array[3][2] = red_circle
      end

      it 'returns true' do
        piece = red_circle
        last_row = 6
        result = game.diagonal_win?(last_row, move, piece)
        expect(result).to be true
      end
    end
  end
end