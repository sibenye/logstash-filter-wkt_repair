# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "open3"

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

    begin
      cmd = "prepair --wkt '#{wkt}'"
      stdout, stderr, status = Open3.capture3("#{cmd}")

      if status.success?
        event.set(@target, stdout.strip)
      else
        @logger.error("WKT Repair Error: #{stderr}", :wkt => wkt)
        @tag_on_failure.each { |tag| event.tag(tag) }
      end
    rescue Exception => e
      @logger.error("WKT Repair Exception", :exception => e)
      @tag_on_failure.each { |tag| event.tag(tag) }
    end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::WktRepair
