require "golden_section/version"
require 'terminal-table'

module GoldenSection

  class GoldenSection

    attr_reader :a, :b, :func, :eps, :extremum, :y1, :table, :x1, :y2, :x2, :k
    @@proportion = 0.618
    MIN = "min"
    MAX = "max"
    ERROR_COLOR_FOR_SHELL_START = "\033[37;1;41m"
    ERROR_COLOR_FOR_SHELL_STOP = "\033[0m"

    def initialize a, b, eps, extremum, func
      raise ArgumentError.new "#{ERROR_COLOR_FOR_SHELL_START}a is not numeric.#{ERROR_COLOR_FOR_SHELL_STOP}" unless a.is_a? Numeric
      raise ArgumentError.new "#{ERROR_COLOR_FOR_SHELL_START}b is not numeric.#{ERROR_COLOR_FOR_SHELL_STOP}" unless b.is_a? Numeric
      raise ArgumentError.new "#{ERROR_COLOR_FOR_SHELL_START}b less than a or b = a.#{ERROR_COLOR_FOR_SHELL_STOP}" if b < a or b == a
      raise ArgumentError.new "#{ERROR_COLOR_FOR_SHELL_START}eps is not numeric.#{ERROR_COLOR_FOR_SHELL_STOP}" unless eps.is_a? Numeric
      raise ArgumentError.new "#{ERROR_COLOR_FOR_SHELL_START}Incorrect eps. 0 < eps < 1.#{ERROR_COLOR_FOR_SHELL_STOP}" if eps > 1 or eps < 0
      raise ArgumentError.new "#{ERROR_COLOR_FOR_SHELL_START}Parameter extremum will be '#{MIN}' or '#{MAX}'#{ERROR_COLOR_FOR_SHELL_STOP}" unless (extremum.is_a? String and
          (extremum.downcase.strip == "#{MIN}" or extremum.downcase.strip == "#{MAX}"))
      raise ArgumentError.new "#{ERROR_COLOR_FOR_SHELL_START}func is not math function.#{ERROR_COLOR_FOR_SHELL_STOP}" unless func.is_a? Proc and
          func.call(Random.rand).is_a? Numeric
      @a = a
      @b = b
      @eps = eps
      @extremum = extremum.downcase.strip == "#{MIN}" ? 1 : -1
      @func = func
      @x1 = @a + (@b - @a) * (1 - @@proportion)
      @y1 = f(@x1)
      @x2 = @a + (@b - @a) * @@proportion
      @y2 = f(@x2)
    end

    def search view_table = false
      i = 0
      @table = Terminal::Table.new :title => "Golden section method (search #{@extremum == 1 ? MIN : MAX}, eps = #{@eps})",
                                   :headings => ['#', 'a', 'b', 'x', 'f(x)'] do |t|
        while (@b - @a).abs > @eps do
          if @extremum * @y1 > @extremum * @y2
            @a = @x1
            @x1 = @x2
            @x2 = @a + (@b - @a) * @@proportion
            @y1 = @y2
            @y2 = f(@x2)
          else
            @b = @x2
            @x2 = @x1
            @x1 = @a + (@b - @a) * (1 - @@proportion)
            @y2 = @y1
            @y1 = f(@x1)
          end
          t.add_row [i += 1, @a, @b, @x1, f(@x1)]
          t.add_separator
        end
        t.add_row ["Answer", "", "", (@a + @b) / 2, f((@a + @b) / 2)]
      end
      if view_table == true
        puts @table
      end

      {
          "x": (@a + @b) / 2,
          "f(x)": f((@a + @b) / 2)
      }

    end

    protected
    def f(x)
      begin
        y = @func.call x
        raise Math::DomainError if y.is_a? Numeric
      rescue Math::DomainError
        puts "#{ERROR_COLOR_FOR_SHELL_START} Function not is defined on interval or return non numeric value #{ERROR_COLOR_FOR_SHELL_STOP}"
        abort
      end
    end
  end
end
