test_1 = [
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

test_2 = [
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

test_3 = [
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

test_4 = [
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

test_5 = [
  [nil,nil,4,6,nil,nil,5,nil,nil],
  [nil,nil,nil,nil,nil,1,8,3,nil],
  [9,nil,nil,nil,nil,2,4,nil,nil],
  [nil,nil,7,nil,1,nil,nil,nil,nil],
  [8,6,nil,nil,9,nil,nil,4,2],
  [nil,nil,nil,nil,8,nil,6,nil,nil],
  [nil,nil,8,3,nil,nil,nil,nil,6],
  [nil,4,6,8,nil,nil,nil,nil,nil],
  [nil,nil,9,nil,nil,7,2,nil,nil]
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

def string_version_of(nested_array)
  nested_array.to_s.delete("],[").delete("[").delete("]")
end

def nested_array_of(string)
  list = string.split(/\W/)
  puts "list #{list}"
  result = []
  9.times do |i|
    result.push([])
    9.times do
      thisnum = list.shift.to_i
      if thisnum == 0
        result[i].push(nil)
      else
        result[i].push(thisnum)
      end
    end
    i += 1
  end
  return result
end

class Cell
  attr_accessor :possibilities, :value, :row, :column, :square
  def initialize(row, column, square, value = nil)
    @possibilities = [1,2,3,4,5,6,7,8,9]
    @value = value
    @row = row
    @column = column
    # @index = index # value 1-81 (I think - might be 0-80) Currently unused, but useful? Not used in guess squares.
    @square = square
  end
end

class Board
  attr_accessor :cells
  attr_reader :original_data, :guess

  def initialize(nested_array)
    @original_data = string_version_of(nested_array)
    @cells = []
    @attempts = 0
    @moves = 0
    @alt_guess #initialize but do not declare. We will put a cell in here later.
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
        # index = @cells.count
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
      # puts "row #{cell.row + 1} column #{cell.column + 1} could still be #{cell.possibilities}"
    end
  end

  def pairs # not currrently used in the program.
    # Ultimately would like to code the logic that allows you to eliminate a pairings of possibilities that necessarily preclude using those numbers in other squares.
    # ie - squares (3,5) and (2,5) are limited to possible values of 8 and 9, which means that 8 and 9 can't appear anywhere else.
    # ALSO - 8 and 9 only appear in as possibilities in squares (3,5) and (2,5), so no other values could occupy those squares.
    # For now, let's just look for exclusive matches.
    @groups.each do |key, type|
      type.each_with_index do |group, x|
        # The return value of a delete function should not be the deleted thing. That is profoundly dumb. We have pop and search for that.
        number_of_open_cells = flatten(group).count(nil)
        # puts "#{key.to_s.chop} #{x+1} has #{number_of_open_cells} open cells."
        # uncomment the lines above
        possibilities = []
        if number_of_open_cells > 2 # why bother if no elimination is possible?
          group.each do |cell|
            if cell.possibilities.length == 2
              possibilities.push(cell.possibilities)
            end
          end
        end
        if possibilities.uniq.length < possibilities.length
          # puts "Matching pair available in #{key.to_s.chop} #{x+1}."
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

  def make_guess
    @cells.each do |cell|
      # Uncomment this line if we need to debug the code.
      # print cell.possibilities
      if !cell.value && cell.possibilities.count == 2
        choices = cell.possibilities
        puts "choices include: #{choices}."
        cell.value = choices.shuffle!.pop
        puts "selected value: #{cell.value}."
        puts "alternate value: #{choices[0]}"
        puts "row #{cell.row + 1} column #{cell.column + 1} is either a #{cell.possibilities[0]} or a #{cell.possibilities[1]}. Examining available solutions if it's a #{cell.value}."
        backup_cell = Cell.new(cell.row, cell.column, cell.square, choices[0])
        @alt_guess = backup_cell
        return
      end
    end
  end

  def backtrack
    puts "this board has resulted in a paradox. Restoring the original board and assuming that the guess was incorrect."
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
        self.make_guess
      end
      self.print_board
      puts "End round #{@attempts}. \n \n"
      if self.paradox?
        puts "Our guess resulted in a paradox..."
        puts "Re-running."
        return @alt_guess
        # return to start, fill in alternate guess before proceeding.
        # may not work for double bifurcation, but should be okay if we pop these JSON objects (hashes) off the end as we rectify them. This may be it, actually.
      elsif self.finished?
        puts "All 81 squares have been filled in! \nSudoku solved in #{@attempts} rounds. \n \n"
        return "solved"
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

class Solver
  attr_reader :guesses_so_far

  def initialize(nested_array)
    @solved = false
    @nested_array = nested_array
    @guesses_so_far = []
    @current_board = Board.new(@nested_array)
  end

  def try_to_solve
    result = @current_board.solve
    if result == "solved"  # if it is successful...
      return "done"
    else
      @guesses_so_far.push(result)
    end
  end

  def solve
    result = self.try_to_solve
    until result == "done" do
      backup_cell = @guesses_so_far.pop
      puts "row #{backup_cell.row}, column #{backup_cell.column} must, by process of elimination, be #{backup_cell.value}"
      @nested_array[backup_cell.row][backup_cell.column] = backup_cell.value
      @current_board = Board.new(@nested_array)
      result = self.try_to_solve
    end
  end

end
# puts "\n-------"
# print test_1
# puts "\n-------"
# pivot1 = string_version_of(test_1)
# print pivot1
# puts "\n-------"
# print nested_array_of(pivot1)


trial = Solver.new(test_5)
trial.solve
