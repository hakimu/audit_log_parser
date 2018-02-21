require 'json'
require_relative 'metric_data'

class AuditLogParser

  def initialize(file_path)
    @log_content = File.readlines(file_path)
    parse_lines
  end

  def lines
    @log_content
  end
  
  def metric_data
    @metric_data ||= MetricData.new(@log_content)
  end

  private

  def parse_lines
    lines.map! do |line|
      regex = /^.*REQUEST BODY:\s/
      if regex.match line
        line.gsub!(regex ,"")
        JSON.parse(line)
      else
        line
      end
    end
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

# To do...
# Set up tests for metric_data
# Organize code.  Use lib, test directory and set up tests helpers to load the files rather than require_relative
# Look into optsparser for the functionality we have
# metric data is for metric events.  down the road we'll have something similar for events, transaction trace, etc.