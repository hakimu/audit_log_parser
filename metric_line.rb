class MetricLine

  attr_accessor :name, :scope, :call_count, :total_call_time, :total_exclusive_time, :min_call_time, :max_call_time, :sum_of_squares

  def initialize(line)
    @name = line[0]["name"]
    @scope = line[0]["scope"]
    @call_count = line[1][0]
    @total_call_time = line[1][1]
    @total_exclusive_time = line[1][2]
    @min_call_time = line[1][3]
    @max_call_time = line[1][4]
    @sum_of_squares = line[1][5]
  end

end

# add attr_accessor for the other parts os a metric (i.e. some of sqs, etc)