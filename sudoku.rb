test_1 = [
  [2,8,1,9,3,4,6,7,5],
  [7,4,6,1,8,5,9,3,2],
  [9,3,5,2,7,6,1,8,4],
  [4,6,2,8,9,3,7,5,1],
  [5,9,7,6,2,1,8,4,3],
  [3,1,8,5,4,7,2,9,6],
  [6,7,9,4,5,2,3,1,8],
  [1,5,3,7,6,8,4,2,9],
  [8,2,4,3,1,9,5,6,7]
]

test_2 = [
  [nil,8,1,9,nil,nil,nil,7,5],
  [7,nil,6,nil,nil,nil,nil,3,nil],
  [nil,nil,nil,2,7,nil,nil,nil,nil],
  [nil,nil,nil,8,9,nil,7,5,1],
  [nil,9,7,nil,2,nil,8,4,nil],
  [3,1,8,nil,4,7,nil,nil,nil],
  [nil,nil,nil,nil,5,2,nil,nil,nil],
  [nil,5,nil,nil,nil,nil,4,nil,9],
  [8,2,nil,nil,nil,9,5,6,nil]
]

test_3 = [
  [7,5,6,1,2,4,3,9,8],
  [9,1,3,7,8,6,5,4,2],
  [2,4,8,3,5,9,7,1,6],
  [4,3,1,6,7,8,2,5,9],
  [5,8,9,4,3,2,1,6,7],
  [6,7,2,5,9,1,8,3,4],
  [8,6,7,9,1,3,4,2,5],
  [1,9,5,2,4,7,6,8,3],
  [3,2,4,8,6,5,9,7,1]
]

test_4 = [
  [7,nil,6,1,nil,nil,nil,nil,8],
  [9,nil,nil,7,8,nil,nil,4,nil],
  [nil,4,nil,nil,nil,9,nil,1,6],
  [nil,3,1,6,nil,nil,nil,nil,nil],
  [nil,nil,9,nil,3,nil,1,nil,nil],
  [nil,nil,nil,nil,nil,1,8,3,nil],
  [8,6,nil,9,nil,nil,nil,2,nil],
  [nil,9,nil,nil,4,7,nil,nil,3],
  [3,nil,nil,nil,nil,5,9,nil,1]
]

test_5 = [
  [4,7,3,5,8,1,6,2,9],
  [1,9,5,7,6,2,3,4,8],
  [2,6,8,9,3,4,5,7,1],
  [7,5,9,8,2,6,1,3,4],
  [6,8,1,3,4,9,7,5,2],
  [3,4,2,1,7,5,9,8,6],
  [5,2,4,6,1,3,8,9,7],
  [8,3,6,4,9,7,2,1,5],
  [9,1,7,2,5,8,4,6,3]
]

test_6 = [
  [nil,nil,nil,nil,8,1,6,nil,nil],
  [1,9,nil,nil,nil,2,nil,4,nil],
  [nil,6,8,nil,nil,4,5,nil,nil],
  [7,nil,9,8,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,4,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,5,9,nil,6],
  [nil,nil,4,6,nil,nil,8,9,nil],
  [nil,3,nil,4,nil,nil,nil,1,5],
  [nil,nil,7,2,5,nil,nil,nil,nil]
]

test_7 = [
  [5,nil,1,nil,nil,nil,8,nil,7],
  [nil,2,nil,nil,nil,nil,nil,3,nil],
  [8,nil,nil,6,nil,5,nil,nil,4],
  [nil,nil,2,5,nil,8,4,nil,nil],
  [nil,nil,nil,nil,6,nil,nil,nil,nil],
  [nil,nil,6,3,nil,1,5,nil,nil],
  [3,nil,nil,2,nil,6,nil,nil,9],
  [nil,8,nil,nil,nil,nil,nil,5,nil],
  [2,nil,9,nil,nil,nil,7,nil,6]
]

paradox_board = [
  [5,nil,1,nil,nil,nil,8,nil,7],
  [nil,2,nil,nil,nil,nil,nil,3,nil],
  [8,nil,nil,6,nil,5,nil,nil,4],
  [nil,nil,2,5,nil,8,4,nil,nil],
  [nil,nil,nil,nil,6,nil,nil,nil,nil],
  [nil,nil,6,3,nil,1,5,nil,nil],
  [3,nil,nil,2,nil,6,nil,nil,9],
  [nil,8,nil,nil,nil,nil,nil,5,nil],
  [2,nil,9,nil,nil,nil,7,nil,6]
]

def flatten(ary)
  values = []
  ary.each do |cell|
    values.push(cell.value)
  end
  return values
end

class Cell
  attr_accessor :possibilities, :value, :row, :column, :square, :index
  def initialize(row, column, square, index, value = nil)
    @possibilities = [1,2,3,4,5,6,7,8,9]
    @value = value
    @row = row
    @column = column
    @index = index
    @square = square
  end
end

class Board
  attr_accessor :cells
  attr_reader :original_data

  def initialize(nested_array)
    @original_data = nested_array
    @cells = []
    @attempts = 0
    @moves = 0
    @guesses = []
    nested_array.each_with_index do |row, y|
      row.each_with_index do |value, x|
        square = nil
        if y < 3
          if x < 3
            square = 0
          elsif x < 6
            square = 1
          else
            square = 2
          end
        elsif y < 6
          if x < 3
            square = 3
          elsif x < 6
            square = 4
          else
            square = 5
          end
        else
          if x < 3
            square = 6
          elsif x < 6
            square = 7
          else
            square = 8
          end
        end
        index = @cells.count
        cells.push(Cell.new(y, x, square, index, value))
      end
    end
    @rows = []
    @columns = []
    @squares = []
    9.times do
      @rows.push([])
      @columns.push([])
      @squares.push([])
    end
    @cells.each do |cell|
      @rows[cell.row].push(cell)
      @columns[cell.column].push(cell)
      @squares[cell.square].push(cell)
    end
    @groups = {
      :rows => @rows,
      :columns => @columns,
      :squares => @squares
    }
  end

  def run_everything
    @groups.each do |key, type|
      i = 0
      type.each do |group|
        i += 1
        used_values = []
        group.each do |cell|
          if cell.value
            used_values.push(cell.value)
          end
        end
        # puts "#{key} #{i} already has #{used_values}"
        group.each do |cell|
          used_values.each do |value|
            cell.possibilities.delete(value)
          end
        end
      end
    end
    self.clean
    @cells.each do |cell|
      puts "row #{cell.row + 1} column #{cell.column + 1} could still be #{cell.possibilities}"
    end
  end

  def pairs
    # Ultimately would like to code the logic that allows you to eliminate a pairings of possibilities that necessarily preclude using those numbers in other squares.
    # ie - squares (3,5) and (2,5) are limited to possible values of 8 and 9, which means that 8 and 9 can't appear anywhere else.
    # ALSO - 8 and 9 only appear in as possibilities in squares (3,5) and (2,5), so no other values could occupy those squares.
    # For now, let's just look for exclusive matches.
    @groups.each do |key, type|
      type.each_with_index do |group, x|
        # The return value of a delete function should not be the deleted thing. That is profoundly dumb. We have pop and search for that.
        number_of_open_cells = flatten(group).count(nil)
        puts "#{key.to_s.chop} #{x+1} has #{number_of_open_cells} open cells."
        possibilities = []
        if number_of_open_cells > 2 # why bother if no elimination is possible?
          group.each do |cell|
            if cell.possibilities.length == 2
              possibilities.push(cell.possibilities)
            end
          end
        end
        if possibilities.uniq.length < possibilities.length
          puts "Matching pair available in #{key.to_s.chop} #{x+1}."
        end
      end
    end
  end

  def poe
    @groups.each do |key, type|
      type.each_with_index do |group, i|
        9.times do |x|
          num = []
          group.each do |cell|
            num.push(cell) if cell.possibilities.include?(x+1)
          end
          if num.count == 1 && num[0].value == nil
            num[0].value = x + 1
            puts "row #{num[0].row + 1} column #{num[0].column + 1} has been filled in with a #{x+1} because it's the only possible #{x+1} left for this #{key.to_s.chop}."
            @moves += 1
          end
        end
      end
      self.clean
    end
  end

  def fill_in_squares
    @moves = 0
    @cells.each do |cell|
      unless cell.value
        if cell.possibilities.count == 1
          cell.value = cell.possibilities[0]
          puts "row #{cell.row + 1} column #{cell.column + 1} has been filled in with a #{cell.value} because nothing else can go here."
          @moves += 1
        end
      end
    end
    # puts "\n#{moves} squares were filled in during round #{@attempts}."
  end

  def print_board
    puts "\n-----------------------------------"
    @cells.each_with_index do |cell, i|
      print cell.value ? cell.value.to_s + " | " : "_ | "
      puts "\n-----------------------------------" if (i+1) % 9 == 0
    end
    puts ""
  end

  def take_a_turn  # one step to solving
    @attempts += 1
    self.run_everything
    self.fill_in_squares
    self.poe
    self.print_board
    puts "End round #{@attempts}."
  end

  def clean
    @cells.each do |cell|
      if cell.value
        cell.possibilities = [cell.value]
      #else
        #possibilities = [1,2,3,4,5,6,7,8,9]
      end
    end
  end

  def guess
    @cells.each do |cell|
      print cell.possibilities
      if !cell.value && cell.possibilities.count == 2
        choices = cell.possibilities
        cell.value = choices.shuffle.pop
        puts "row #{cell.row + 1} column #{cell.column + 1} is either a #{cell.possibilities[0]} or a #{cell.possibilities[1]}. Examining available solutions if it's a #{cell.value}."
        backup_cell = Cell.new(cell.row, cell.column, cell.square, choices[0])
        @guesses.push(backup_cell)
        return
      end
    end
  end

  def backtrack
    # make a new board from the original data
    # clone the cells from the new board
    # fill in the alternate guess from above
    # continue solving as usual
    backup = Board.new(@original_data)
    backup.cells[conclusion_cell.index] = conclusion_cell
    ## Need to switch boards though - groups are fucking me up.
  end

  def solve
    self.print_board
    until self.finished? || @attempts >= 30
      @moves = 0
      @attempts += 1
      self.run_everything
      self.fill_in_squares
      self.poe
      puts "\n#{@moves} squares were filled in during round #{@attempts}."
      if @moves == 0
        self.pairs
        puts "Since no squares were filled in, we're initiating a guess."
        self.guess
      end
      self.print_board
      puts "End round #{@attempts}. \n \n"
      if self.finished?
        puts "All 81 squares have been filled in! \nSudoku solved in #{@attempts} rounds. \n \n"
        puts "This solution used #{@guesses.count} guesses."
      end
      if self.paradox?
        self.backtrack
        # return to start, fill in alternate guess before proceeding.
        # may not work for double bifurcation, but should be okay if we pop these JSON objects (hashes) off the end as we rectify them. This may be it, actually.
      end
    end
  end

  def total?
    total = 0
    @cells.each do |cell|
      total += 1 if cell.value
    end
    return total
  end

  def finished?
    if self.total? == 81
      return true
    else
      return false
    end
  end


  def paradox?
    i = 1
    @groups.each do |key, type|
      type.each_with_index do |group, x|
        values = flatten(group)
        values.delete(nil)
        if values.uniq.length != values.length
          puts "Our guess resulted in a paradox in #{key.to_s.chop} #{x+1}."
          return true
        end
      end
    end
    return false
  end


end

trial = Board.new(test_7)
trial.solve


# print trial.cells


# loop skeleton code
# 20.times { puts "" }
# response = ""
# puts "Welcome to the sudoku solver. Your preloaded puzzle is as follows:"
# trial.print_board
# until response.downcase == "q" || response.downcase == "quit" || response.downcase == "exit"
#   puts "Type 'quit' to leave the solver. Press 'enter' to fill in whatever's next."
#   response = gets.chomp
#   unless response.downcase == "q" || response.downcase == "quit" || response.downcase == "exit"
#     trial.solve
#   end
# end
