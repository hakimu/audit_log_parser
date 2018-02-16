require 'json'
require_relative 'metric_data_post'

class AuditLogParser

  def initialize(file_path)
    @log_content = File.readlines(file_path)
  end

  def lines
    @log_content
  end

  def metric_data_lines
    parsed_log = []
    @log_content.each_with_index do |line, index|
      if line.include? "metric_data?"
        parsed_log << @log_content[index+1]
      end
    end
    parsed_log
  end

  def parse_line(line)
    parsed_line = line.gsub(/^.*REQUEST BODY:\s/,"")
    JSON.parse(parsed_line)
  end

  def parse_metric_data_lines
    metric_data_lines.map do |line|
      parse_line(line)
    end
  end

  def metric_data_posts
    @metric_data_posts ||= parse_metric_data_lines.map {|post| MetricDataPost.new(post)}
  end

  def extract_metric(name)
    results = []
    metric_data_posts.each do |post|
      if result = post.metrics.detect {|metric| metric.name == name}
        results << result
      end
    end
    results
  end

  def sum_call_count(metric_name)
    extract_metric(metric_name).inject(0) {|memo,metric| memo + metric.call_count}
  end

  def metric_data_time_window
    [@metric_data_posts.first.start_time, @metric_data_posts.last.end_time].map{|timestamp| Time.at(timestamp)}
  end

end

# create a metric data object to have a distinction between metric data and transaction event data, etc.
# the metric_data_time_window method should be moved to the metricdata object
# method to give the overall time window on the metric data object


# log_contents = AuditLogParser.new("metric_one_line.txt")
# # log_contents = AuditLogParser.new("audit_log_fixture.txt")
# puts log_contents.inspect
# # log_contents = AuditLogParser.new("audit_log_fixture.txt")
# puts log_contents.class
# puts log_contents.parse_metric_data_lines