require 'minitest/autorun'
require 'minitest/rg'

require_relative 'metric_data'

class MetricDataTest < Minitest::Test 
  
  def setup
    @audit_log = MetricData.new
    # @metric_names = ["GC/foo/baz","WebTransaction/controller", "OtherTransaction/nonweb","Controller/user/index","Nested/Controller/user/index"]
    # @start_timestamps = [1.332,15.03243,14.2121,15.6774,12.343243]
    # @end_timestamps = [1.535,15.134324,14.463,15.959232,12.865454]
    # @call_counts = [56,1,2,3,4]
  end

  def test_output
  #   expected = [["GC/foo/baz", 1.332, 1.535, 56], ["WebTransaction/controller", 15.03243, 15.134324, 1], ["OtherTransaction/nonweb", 14.2121, 14.463, 2], ["Controller/user/index", 15.6774, 15.959232, 3], ["Nested/Controller/user/index", 12.343243, 12.865454, 4]]
  #   assert_equal expected, @metric_names
    assert_equal 1, @audit_log.output
  end
end