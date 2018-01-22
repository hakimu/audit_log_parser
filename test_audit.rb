require 'minitest/autorun'
require 'minitest/rg'

require_relative 'audit'

class AuditLogTest < Minitest::Test

  def setup
    file = "audit_log_fixture.txt"
    @audit_log = AuditLogParser.new(file)
  end

  def test_reads_lines
    assert_equal 100, @audit_log.lines.size
  end

  def test_read_metric_data_post 
    assert_equal 14, @audit_log.metric_data_lines.size
  end

  def test_find_timestamp
    data = @audit_log.lines.each {|log| log.scan(/\(\d{5}\)\]\s:\sREQUEST BODY:\s\["/)}
    assert_equal data, @audit_log.parse_logs
  end

  def test_parse_both_timestamps
    assert_equal ["1509137330.405039,1509137393.893826"], @audit_log.timestamps[0]
    assert_equal ["1509137393.8938391,1509137453.6925461"], @audit_log.timestamps[1]
    assert_equal ["1509137453.6925492,1509137513.696147"], @audit_log.timestamps[2]
  end

  # def test_name_call_count
  #   assert_equal [[{"name":"Supportability/API/record_metric","scope":""},[56,0.0,0.0,0.0,0.0,0.0]]], @audit_log.name_call_count[0][0]
  # end

  def test_deserialize_from_json
    log_line = '[2017-10-27 13:49:53 -0700 mwear (6523)] : REQUEST BODY: ["run123",1509137330.405039,1509137393.893826,[[{"name":"Supportability/API/record_metric","scope":""},[56,0.0,0.0,0.0,0.0,0.0]]]]'
    parsed_line = @audit_log.parse_line(log_line)
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

  def test_parse_run_id_from_json
    log_line = '[2017-10-27 13:49:53 -0700 mwear (6523)] : REQUEST BODY: ["run123",1509137330.405039,1509137393.893826,[[{"name":"Supportability/API/record_metric","scope":""},[56,0.0,0.0,0.0,0.0,0.0]]]]'
    expected = "run123"
    run_id = @audit_log.parse_run_id(log_line)
    assert_equal expected, run_id
  end

  def test_parse_metric_name_from_json
    log_line = '[2017-10-27 13:49:53 -0700 mwear (6523)] : REQUEST BODY: ["run123",1509137330.405039,1509137393.893826,[[{"name":"Supportability/API/record_metric","scope":""},[56,0.0,0.0,0.0,0.0,0.0]]]]'
    expected = "Supportability/API/record_metric"
    metric_name = @audit_log.parse_metric_name(log_line)
    assert_equal expected, metric_name
  end

  def test_parse_start_timestamp
    log_line = '[2017-10-27 13:49:53 -0700 mwear (6523)] : REQUEST BODY: ["run123",1509137330.405039,1509137393.893826,[[{"name":"Supportability/API/record_metric","scope":""},[56,0.0,0.0,0.0,0.0,0.0]]]]'
    expected = 1509137330.405039
    start_timestamp = @audit_log.parse_start_timestamp(log_line)
    assert_equal expected, start_timestamp
  end

  def test_parse_end_timestamp
    log_line = '[2017-10-27 13:49:53 -0700 mwear (6523)] : REQUEST BODY: ["run123",1509137330.405039,1509137393.893826,[[{"name":"Supportability/API/record_metric","scope":""},[56,0.0,0.0,0.0,0.0,0.0]]]]'
    expected = 1509137393.893826
    end_timestamp = @audit_log.parse_end_timestamp(log_line)
    assert_equal expected, end_timestamp
  end

  def test_parse_call_count
    log_line = '[2017-10-27 13:49:53 -0700 mwear (6523)] : REQUEST BODY: ["run123",1509137330.405039,1509137393.893826,[[{"name":"Supportability/API/record_metric","scope":""},[56,0.0,0.0,0.0,0.0,0.0]]]]'
    expected = 56
    call_count = @audit_log.parse_call_count(log_line)
    assert_equal expected, call_count
  end



end

# Possible regex \w",(\d+.\d+,\d+.\d+),

# create class for metric data post with attributes for timestamp, name of metric, accessor for value in the metric (i.e. sum of squares, exclusive, call count)
# parse line to get the timestamp value and the json that represents the post
# user json.parse to turn json into a hash
# My ideas...Have data displayed by PID showing the metric, start time, end time, metric count, value, etc.
# Have the data display so it matches up with the metric data dump page
# See if you can use a Struct


# Here's a regex that may work - \(\d{5}\)\]\s:\sREQUEST BODY:\s\["

# name: Supportability/invoke_remote_serialize/connect\n      
# scope: ''\n    
# stats: !ruby/object:NewRelic::Agent::Stats\n      
# call_count: 1\n      
# total_call_time: 0.001293\n      
# total_exclusive_time: 0.001293\n      
# min_call_time: 0.001293\n      
# max_call_time: 0.001293\n      
# sum_of_squares: 1.6718490000000003e-06\n  - 
# !ruby/object:NewRelic::MetricData\n    
# original_spec: \n    
# metric_spec: 
# !ruby/object:NewRelic::MetricSpec\n

# [2017-10-27 13:49:53 -0700 mwear (6523)] : REQUEST BODY: ["WzIse2E6NzU5ODk0OCxiOjQwODUzODQsYzozODA1NjIsZDoiNC42LjAiLGU6InJ1YnkiLGY6Im13ZWFyIixnOlt7YTo0MDg1MzgzLGI6InBsYXlncm91bmQgKHJhaWxzNCt1bmljb3JuKSJ9XX0sMTgyOTg3NjM0XQ",1509137330.405039,1509137393.893826,[[{"name":"Supportability/API/record_metric","scope":""},[56,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success","scope":""},[16,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Gems","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/error","scope":""},[3,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/error/Plugin List","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Ruby version","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Ruby description","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Ruby platform","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Ruby patchlevel","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/error/JRuby version","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/error/Java VM version","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Logical Processors","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Physical Cores","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Arch","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/empty","scope":""},[2,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/empty/OS version","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/OS","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Database adapter","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Framework","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Dispatcher","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Environment","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Rails version","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/empty/Rails threadsafe","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/Rails Env","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/EnvironmentReport/success/OpenSSL version","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/API/disable_all_tracing","scope":""},[5,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/API/add_method_tracer","scope":""},[1,0.0,0.0,0.0,0.0,0.0]],[{"name":"Supportability/invoke_remote","scope":""},[2,1.0102,1.0102,0.29245,0.71775,0.600692065]],[{"name":"Supportability/invoke_remote/get_redirect_host","scope":""},[1,0.29245,0.29245,0.29245,0.29245,0.08552700249999999]],[{"name":"Supportability/invoke_remote_serialize","scope":""},[2,0.001245,0.001245,4.9e-05,0.001196,1.4328170000000001e-06]],[{"name":"Supportability/invoke_remote_serialize/get_redirect_host","scope":""},[1,4.9e-05,4.9e-05,4.9e-05,4.9e-05,2.401e-09]],[{"name":"Supportability/invoke_remote_size","scope":""},[2,8379.0,0.0,2.0,8377.0,70174133.0]],[{"name":"Supportability/invoke_remote_size/get_redirect_host","scope":""},[1,2.0,0.0,2.0,2.0,4.0]],[{"name":"Supportability/invoke_remote/connect","scope":""},[1,0.71775,0.71775,0.71775,0.71775,0.5151650625]],[{"name":"Supportability/invoke_remote_serialize/connect","scope":""},[1,0.001196,0.001196,0.001196,0.001196,1.4304160000000001e-06]],[{"name":"Supportability/invoke_remote_size/connect","scope":""},[1,8377.0,0.0,8377.0,8377.0,70174129.0]],[{"name":"CPU/System Time","scope":""},[1,0.06,0.06,0.06,0.06,0.0036]],[{"name":"CPU/User Time","scope":""},[1,0.16000000000000014,0.16000000000000014,0.16000000000000014,0.16000000000000014,0.025600000000000046]],[{"name":"CPU/User/Utilization","scope":""},[1,0.0003167998752061934,0.0003167998752061934,0.0003167998752061934,0.0003167998752061934,1.0036216093065972e-07]],[{"name":"CPU/System/Utilization","scope":""},[1,0.00011879995320232242,0.00011879995320232242,0.00011879995320232242,0.00011879995320232242,1.4113428880873997e-08]],[{"name":"Memory/Physical","scope":""},[1,68.94921875,68.94921875,68.94921875,68.94921875,4753.994766235352]],[{"name":"RubyVM/GC/runs","scope":""},[0,1.0,0.006987999999999106,0.0,1.0,63.13300824165344]],[{"name":"RubyVM/GC/total_allocated_object","scope":""},[0,170307.0,0.0,0.0,0.0,0.0]],[{"name":"RubyVM/GC/minor_gc_count","scope":""},[0,1.0,0.0,0.0,0.0,0.0]],[{"name":"RubyVM/CacheInvalidations/method","scope":""},[0,3.0,0.0,0.0,0.0,0.0]],[{"name":"RubyVM/CacheInvalidations/constant","scope":""},[0,640.0,0.0,0.0,0.0,0.0]],[{"name":"RubyVM/GC/heap_live","scope":""},[305886,0.0,0.0,0.0,0.0,1.0]],[{"name":"RubyVM/GC/heap_free","scope":""},[3886,0.0,0.0,0.0,0.0,1.0]],[{"name":"RubyVM/Threads/all","scope":""},[2,0.0,0.0,0.0,0.0,1.0]],[{"name":"Instance/Busy","scope":""},[1,0.0,0.0,0.0,0.0,0.0]]]]


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
