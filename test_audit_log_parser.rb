require 'minitest/autorun'
require 'minitest/rg'

require_relative 'audit_log_parser'

class AuditLogParserTest < Minitest::Test

  def setup
    @log_line = '[2017-10-27 13:49:53 -0700 mwear (6523)] : REQUEST BODY: ["run123",1509137330.405039,1509137393.893826,[[{"name":"Supportability/API/record_metric","scope":""},[56,0.0,0.0,0.0,0.0,0.0]]]]'
    file = "audit_log_fixture.txt"
    @audit_log = AuditLogParser.new(file)
  end

  def test_reads_lines
    assert_equal 100, @audit_log.lines.size
  end

  def test_read_metric_data_post 
    assert_equal 14, @audit_log.metric_data_lines.size
  end

  def test_deserialize_from_json
    parsed_line = @audit_log.parse_line(@log_line)
    expected = ["run123",1509137330.405039,1509137393.893826,
                 [
                    [
                      {"name" => "Supportability/API/record_metric","scope" => ""},
                      [56,0.0,0.0,0.0,0.0,0.0]
                    ]
                  ]
                ]
    assert_equal expected, parsed_line
  end

  def test_metric_data_posts
    assert_equal 14, @audit_log.metric_data_posts.count
    assert @audit_log.metric_data_posts.all? {|post| post.is_a? MetricDataPost }
  end

  # def test_parse_run_id_from_json
  #   expected = "run123"
  #   run_id = @audit_log.parse_run_id(@log_line)
  #   assert_equal expected, run_id
  # end

  # def test_parse_metric_name_from_json
  #   expected = "Supportability/API/record_metric"
  #   metric_name = @audit_log.parse_metric_name(@log_line)
  #   assert_equal expected, metric_name
  # end

  # def test_parse_start_timestamp
  #   expected = 1509137330.405039
  #   start_timestamp = @audit_log.parse_start_timestamp(@log_line)
  #   assert_equal expected, start_timestamp
  # end

  # def test_parse_end_timestamp
  #   expected = 1509137393.893826
  #   end_timestamp = @audit_log.parse_end_timestamp(@log_line)
  #   assert_equal expected, end_timestamp
  # end

  # def test_parse_call_count
  #   expected = 56
  #   call_count = @audit_log.parse_call_count(@log_line)
  #   assert_equal expected, call_count
  # end

end

# create class for metric data post with attributes for timestamp, name of metric, accessor for value in the metric (i.e. sum of squares, exclusive, call count)
# parse line to get the timestamp value and the json that represents the post
# user json.parse to turn json into a hash
# Have data displayed by PID showing the metric, start time, end time, metric count, value, etc.
# Have the data display so it matches up with the metric data dump page

# [11] pry(#<NewRelic::Agent::AuditLogger>)> puts data.to_yaml
# ---
# - WzIse2E6MTY5NTg4NzIzOCxiOjEwMDM4NTk5OCxjOjUyNzkzMCxkOiI0LjYuMC4zMzgiLGU6InJ1YnkiLGY6Imhha2ltdS1tYnAiLGc6W3thOjEwMDM4NTk5NyxiOiJOb3RlQ2FyZCAoRGV2ZWxvcG1lbnQpIn1dfSwzNzc4Mjg2ODIwXQ
# - 1514950079.162518
# - 1514950489.66834
# - - !ruby/object:NewRelic::MetricData
#     original_spec:
#     metric_spec: !ruby/object:NewRelic::MetricSpec
#       name: Supportability/API/record_metric
#       scope: ''
#     stats: !ruby/object:NewRelic::Agent::Stats
#       call_count: 56
#       total_call_time: 0.0
#       total_exclusive_time: 0.0
#       min_call_time: 0.0
#       max_call_time: 0.0
#       sum_of_squares: 0.0
