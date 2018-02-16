require 'minitest/autorun'
require 'minitest/rg'

require_relative 'metric_data'

class MetricDataTest < Minitest::Test 
  
  def setup
    @audit_log = MetricData.new
  end

end