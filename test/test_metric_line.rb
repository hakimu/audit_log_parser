require 'minitest/autorun'
require 'minitest/rg'
require 'test_helper'

class TestMetricLine < Minitest::Test

  def setup
    data = [{"name"=>"Supportability/invoke_remote_size", "scope"=>""}, [2, 8379.0, 0.0, 2.0, 8377.0, 70174133.0]]
    @line = MetricLine.new(data)
  end

  def test_line_has_a_name
    expected = "Supportability/invoke_remote_size"
    assert_equal expected, @line.name
  end

  def test_metric_line_has_a_scope
    expected = ""
    assert_equal expected, @line.scope
  end

  def test_metric_has_a_call_count
    expected = 2
    assert_equal expected, @line.call_count
  end

  def test_total_call_time
    expected = 8379.0
    assert_equal expected, @line.total_call_time
  end

  def test_total_exclusive_time
    expected = 0.0
    assert_equal expected, @line.total_exclusive_time
  end

  def test_min_call_time
    expected = 2.0
    assert_equal expected, @line.min_call_time
  end

  def test_max_call_time
    expected = 8377.0
    assert_equal expected, @line.max_call_time
  end

  def test_sum_of_squares
    expected = 70174133.0
    assert_equal expected, @line.sum_of_squares
  end

end
