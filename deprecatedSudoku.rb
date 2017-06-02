
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


class Cell
  attr_accessor :possibilities, :value, :row, :column, :square
  def initialize(row, column, square, value = nil)
    @possibilities = []
    9.times {@possibilities.push(true)}
    @value = value
    #  potentially useless code, as the validator undoes this.
    # if @value.to_i > 0
    #   9.times {|i| @possibilities[i] = false}
    #   @possibilities[@value-1] = true
    # end
    @row = row
    @column = column
    @square = square
  end
end

class Board
  attr_accessor :cells

  def initialize(nested_array)
    @cells = []
    @attempts = 0
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
        cells.push(Cell.new(y, x, square, value))
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
    @groups.each do |type, ary|
      i = 0
      ary.each do |group|
        i += 1
        used_values = []
        group.each do |cell|
          if cell.value
            used_values.push(cell.value)
          end
        end
        # puts "#{type} #{i} already has #{used_values}"
        group.each do |cell|
          used_values.each do |value|
            cell.possibilities[value-1] = false
          end
        end
      end
    end
  end

  def run_the_rows
    9.times do |i|
      row = []
      @cells.each do |cell|
        if cell.row == i
          row.push(cell)
        end
      end
      used_values = []
      row.each do |cell|
        if cell.value
          used_values.push(cell.value)
        end
      end
      # puts "row #{i} already has #{used_values}"
      row.each do |cell|
        used_values.each do |value|
          cell.possibilities[value-1] = false
        end
      end
    end
  end

  def run_the_columns
    9.times do |i|
      column = []
      @cells.each do |cell|
        if cell.column == i
          column.push(cell)
        end
      end
      used_values = []
      column.each do |cell|
        if cell.value
          used_values.push(cell.value)
        end
      end
      # debug output for values
      # puts "column #{i} already has #{used_values}"
      column.each do |cell|
        used_values.each do |value|
          cell.possibilities[value-1] = false
        end
      end
    end
  end

  def run_the_squares
    9.times do |i|
      square = []
      @cells.each do |cell|
        if cell.square == i
          square.push(cell)
        end
      end
      used_values = []
      square.each do |cell|
        if cell.value
          used_values.push(cell.value)
        end
      end
      # debug output for values
      # puts "square #{i} already has #{used_values}"
      square.each do |cell|
        used_values.each do |value|
          cell.possibilities[value-1] = false
        end
      end
    end
  end

  def poe
    @groups.each do |type, ary|
      ary.each_with_index do |group, i|
        9.times do |x|
          num = []
          group.each do |cell|
            num.push(cell) if cell.possibilities[x] == true
          end
          if num.count == 1 && num[0].value == nil
            num[0].value = x + 1
            puts "Cell in row #{num[0].row}, col #{num[0].column} has been filled in with a #{x+1}."
          end
        end
      end
      self.clean
    end
  end

  def poe_rows
    9.times do |i|
      row = []
      @cells.each do |cell|
        if cell.row == i
          row.push(cell)
        end
      end
      # if the row has only one cell that could possibly be a value, then set that cell to that value
      9.times do |x|
        num = []
        row.each do |cell|
          num.push(cell) if cell.possibilities[x] == true
        end
        if num.count == 1 && num[0].value == nil
          num[0].value = x + 1
          puts "Cell in row #{num[0].row}, col #{num[0].column} has been filled in with a #{x+1}."
        end
      end
    end
  end

  def poe_columns
    9.times do |i|
      column = []
      @cells.each do |cell|
        if cell.column == i
          column.push(cell)
        end
      end
      # if the column has only one cell that could possibly be a value, then set that cell to that value
      9.times do |x|
        num = []
        column.each do |cell|
          num.push(cell) if cell.possibilities[x] == true
        end
        if num.count == 1 && num[0].value == nil
          num[0].value = x + 1
          puts "Cell in row #{num[0].row}, col #{num[0].column} has been filled in with a #{x+1}."
        end
      end
    end
  end

  def poe_squares
    9.times do |i|
      square = []
      @cells.each do |cell|
        if cell.square == i
          square.push(cell)
        end
      end
      # if the row has only one cell that could possibly be a value, then set that cell to that value
      9.times do |x|
        num = []
        square.each do |cell|
          num.push(cell) if cell.possibilities[x] == true
        end
        # puts "Square #{i+1} for number #{x+1} has #{num.count} possibilties"
        if num.count == 1 && num[0].value == nil
          num[0].value = x + 1
          puts "Cell in row #{num[0].row}, col #{num[0].column} has been filled in with a #{x+1}."
        end
      end
    end
  end

  def fill_in_squares
    moves = 0
    @cells.each do |cell|
      unless cell.value
        if cell.possibilities.count(true) == 1
          cell.value = cell.possibilities.index(true) + 1
          puts "row #{cell.row} column #{cell.column} has been filled in with a #{cell.value}"
          moves += 1
        end
      end
    end
    puts "\n#{moves} squares were filled in during round #{@attempts}."
  end

  def print_board
    puts "\n-----------------------------------"
    @cells.each_with_index do |cell, i|
      print cell.value ? cell.value.to_s + " | " : "_ | "
      puts "\n-----------------------------------" if (i+1) % 9 == 0
    end
    puts ""
  end

  def solve
    @attempts += 1
    self.run_the_rows
    self.run_the_columns
    self.run_the_squares
    self.fill_in_squares
    self.print_board
    puts "End round #{@attempts}."
  end

  def clean
    @cells.each do |cell|
      if cell.value
        cell.possibilities.count.times do |i|
          cell.possibilities[i] = false
        end
        cell.possibilities[cell.value-1] = true
      end
    end
  end

  def solve_in(rounds)
    i = 0
    rounds.times do
      @attempts += 1
      i += 1
      self.run_everything
      self.fill_in_squares
      self.poe
      # self.clean
      # self.poe_rows
      # self.clean
      # self.poe_squares
      # self.clean
      # self.poe_columns
      # self.clean
      self.print_board
      puts "End round #{i}."
    end
  end

end

trial = Board.new(test_6)
trial.solve_in(20)
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



# class Sudoku
#   attr_accessor
#   def initialize
#     board = [
#       [nil,nil,nil,nil,nil,nil,nil,nil,nil],
#       [nil,nil,nil,nil,nil,nil,nil,nil,nil],
#       [nil,nil,nil,nil,nil,nil,nil,nil,nil],
#       [nil,nil,nil,nil,nil,nil,nil,nil,nil],
#       [nil,nil,nil,nil,nil,nil,nil,nil,nil],
#       [nil,nil,nil,nil,nil,nil,nil,nil,nil],
#       [nil,nil,nil,nil,nil,nil,nil,nil,nil],
#       [nil,nil,nil,nil,nil,nil,nil,nil,nil],
#       [nil,nil,nil,nil,nil,nil,nil,nil,nil]
#     ]
#     status = "unfinished"
#   end
#
#   def check_rows
#     row_status = []
#     board.each do |row|
#       if row.uniq.count == row.uniq.count
#     end
#   end
# end

def check_group(board)
  group_status = []
  board.each do |group|
    if group.uniq == group
      group_status.push(true)
    else
      group_status.push(false)
    end
  end
  if group_status.include?(false)
    return false
  else
    return true
  end
end

def check_rows(board)
  if check_group(board)
    return "rows complete!"
  else
    return "rows incomplete"
  end
end

def check_columns(board)
  if check_group(invert(board))
    return "columns complete!"
  else
    return "columns incomplete"
  end
end

def check_squares(board)
  if check_group(square_board(board))
    return "squares complete!"
  else
    return "squares incomplete"
  end
end

def invert(board)
  board_by_columns = []
  9.times { board_by_columns.push([]) }
  board.each do |row|
    row.each_with_index do |cell, column|
      board_by_columns[column].push(cell)
    end
  end
  board_by_columns
end

def square_board(board)
  board_by_squares = []
  9.times { board_by_squares.push([]) }
  board.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      if y < 3
        if x < 3
          board_by_squares[0].push(cell)
        elsif x < 6
          board_by_squares[1].push(cell)
        else
          board_by_squares[2].push(cell)
        end
      elsif y < 6
        if x < 3
          board_by_squares[3].push(cell)
        elsif x < 6
          board_by_squares[4].push(cell)
        else
          board_by_squares[5].push(cell)
        end
      else
        if x < 3
          board_by_squares[6].push(cell)
        elsif x < 6
          board_by_squares[7].push(cell)
        else
          board_by_squares[8].push(cell)
        end
      end
    end
  end
  board_by_squares
end

# tests the solution check code
# puts check_rows(test_1)
# puts check_columns(test_1)
# print square_board(test_1)
# puts check_squares(test_1)
