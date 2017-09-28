# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

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
      cmd = "prepair --wkt #{wkt}"
      wkt_repaired = `#{cmd}`
      event.set(@target, wkt_repaired)
    rescue Exception => e
      @logger.error('WKT Repair Error', :exception => e)
      @tag_on_failure.each { |tag| event.tag(tag) }
    end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::WktRepair
