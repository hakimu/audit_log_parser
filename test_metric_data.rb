require 'minitest/autorun'
require 'minitest/rg'

require_relative 'metric_data'

class MetricDataTest < Minitest::Test 
  
  def setup
    @audit_log = MetricData.new
  end

  def test_output_two_log_lines
    expected = [["Supportability/API/record_metric", 1509137330.405039, 1509137393.893826, 56]]
    assert_equal expected, @audit_log.output
  end
end