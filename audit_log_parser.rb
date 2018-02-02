require 'json'

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

  def parse_run_id(line)
    parse_line(line)[0]
  end

  def parse_metric_name(line)
    parse_line(line)[3][0][0]["name"]
  end

  def parse_start_timestamp(line)
    parse_line(line)[1]
  end

  def parse_end_timestamp(line)
    parse_line(line)[2]
  end

  def parse_call_count(line)
    parse_line(line)[3][0][1][0]
  end

  def get_all_ids
    run_ids = []
    metric_data_lines.map do |line|
      run_ids << parse_run_id(line)
    end
    run_ids
  end

  def get_all_metric_names
    metric_names = []
    metric_data_lines.map do |line|
      metric_names << parse_metric_name(line)
    end
    metric_names
  end

  def get_start_timestamps
    start_timestamps = []
    metric_data_lines.map do |line|
      start_timestamps << parse_start_timestamp(line)
    end
    start_timestamps
  end

  def get_end_timestamps
    end_timestamps = []
    metric_data_lines.map do |line|
      end_timestamps << parse_end_timestamp(line)
    end
    end_timestamps
  end

  def get_call_counts
    call_counts = []
    metric_data_lines.map do |line|
      call_counts << parse_call_count(line)
    end
    call_counts
  end

end


