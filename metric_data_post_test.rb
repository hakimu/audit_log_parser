require 'minitest/autorun'
require 'minitest/rg'

require_relative 'metric_data_post'

class MetricDataPostTest < Minitest::Test

  def setup
    file = File.read("metric_post_fixture.txt")
    data = JSON.parse(file)
    @post = MetricDataPost.new(data)
  end

  def test_post_has_agent_run_id
    expected = "WzIse2E6NzU5ODk0OCxiOjQwODUzODQsYzozODA1NjIsZDoiNC42LjAiLGU6InJ1YnkiLGY6Im13ZWFyIixnOlt7YTo0MDg1MzgzLGI6InBsYXlncm91bmQgKHJhaWxzNCt1bmljb3JuKSJ9XX0sMTgyOTg3NjM0XQ"
    assert_equal expected, @post.agent_run_id
  end

  def test_post_has_start_time
    expected = 1509137330.405039
    assert_equal expected, @post.start_time
  end

  def test_post_has_end_time
    expected = 1509137393.893826
    assert_equal expected, @post.end_time
  end

  def test_post_has_array_of_metrics
    assert_equal 50, @post.metrics.size
  end

end