require_relative 'audit_log_parser'
require_relative 'metric_data_post'

class MetricData

  def initialize(log_content)
    @log_content = log_content
  end

  def posts
    @posts ||= metric_data_lines.map {|post| MetricDataPost.new(post)}
  end

  def extract_metric(name)
    results = []
    posts.each do |post|
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
    [@posts.first.start_time, @posts.last.end_time].map{|timestamp| Time.at(timestamp)}
  end

  private

  def metric_data_lines
    parsed_log = []
    @log_content.each_with_index do |line, index|
      if line.include? "metric_data?"
        parsed_log << @log_content[index+1]
      end
    end
    parsed_log
  end

end


# MetricData.new.output