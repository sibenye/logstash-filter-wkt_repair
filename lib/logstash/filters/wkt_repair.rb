# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "open3"
require 'securerandom'

class LogStash::Filters::WktRepair < LogStash::Filters::Base

  # Usage:
  # [source,ruby]
  # ----------------------------------
  # wkt_repair => {
  #  "source" => "name of field containing WKT shape data"
  #  "target" => "name of field to put the repaired WKT"
  # }
  # ----------------------------------
  config_name "wkt_repair"
  
  config :source, :validate => :string, :required => true
  config :target, :validate => :string, :default => 'wkt_repaired'
  config :tag_on_failure, :validate => :array, :default => [ '_wkt_repair_failure' ]

  public
  def register
    # Add instance variables 
  end # def register

  public
  def filter(event)

    wkt = event.get(@source)
    event_uuid = SecureRandom.uuid
    random_hex = SecureRandom.hex(10)
    temp_file = "temp-wkt_#{event_uuid}_#{random_hex}.txt"

    unless wkt.nil?
      begin
        IO.write(temp_file, wkt)

        wkt_repair_cmd = "prepair -f #{temp_file}"
        stdout, stderr, status = Open3.capture3("#{wkt_repair_cmd}")
        
        if (status.success? && !stdout.nil?)
          event.set(@target, stdout.strip)
        else
          @logger.error("WKT Repair Error: #{stderr}")
          @logger.error("WKT Repair Output Message: #{stdout}")
          @tag_on_failure.each { |tag| event.tag(tag) }
        end
      rescue Exception => e
        @logger.error("WKT Repair Exception", :exception => e, :stacktrace => e.backtrace.join("\n"))
        @tag_on_failure.each { |tag| event.tag(tag) }
      ensure
        begin
          if File.file?(temp_file)
            File.delete(temp_file)
          end
        rescue Exception => e
          @logger.error("WKT Repair Exception in ensure block", :exception => e, :stacktrace => e.backtrace.join("\n"))
        end
      end
    end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::WktRepair
