require_relative 'metric_data'

require 'minitest/autorun'
require 'minitest/rg'



class MetricDataTest < Minitest::Test

  def setup
    file = "audit_log_fixture.txt"
    @audit_log = AuditLogParser.new(file)
    @metric_data = @audit_log.metric_data
  end

  def test_read_metric_data_post 
    assert_equal 14, @metric_data.posts.size
  end

  def test_metric_data_posts
    assert_equal 14, @metric_data.posts.count
    assert @metric_data.posts.all? {|post| post.is_a? MetricDataPost }
  end
end