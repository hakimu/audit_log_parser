require 'json'
require_relative 'audit_log_parser'
require_relative 'metric_line'

class MetricDataPost

  attr_accessor :agent_run_id, :start_time, :end_time, :metrics

  def initialize(data)
    @agent_run_id = data[0]
    @start_time = data[1]
    @end_time = data[2]
    @metrics = data[3].map {|line| MetricLine.new(line)}
    # require 'pry' ; binding.pry
  end

end

