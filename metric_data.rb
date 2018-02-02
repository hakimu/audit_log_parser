require_relative 'audit_log_parser'

class MetricData

  def initialize
    puts "ARGV[0] is #{ARGV[0]}"
    file = (ARGV[0] || "audit_log_fixture.txt")
    audit_logs = AuditLogParser.new(file)
    @metric_names = audit_logs.get_all_metric_names
    @start_timestamps = audit_logs.get_start_timestamps
    @end_timestamps = audit_logs.get_end_timestamps
    @call_counts = audit_logs.get_call_counts
  end

  attr_accessor :metric_names, :start_timestamps, :end_timestamps, :call_counts

  def output
    @metric_names.zip(@start_timestamps, @end_timestamps, @call_counts)
  end

end

# puts MetricData.new.output.count