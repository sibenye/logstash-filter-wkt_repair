# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/wkt_repair"

describe LogStash::Filters::WktRepair do
  describe "Set to Hello World" do
    let(:config) do <<-CONFIG
      filter {
        wkt_repair {
          source => "geometry"
          target => "geometry"
        }
      }
    CONFIG
    end

    sample("geometry" => "POLYGON((0 0, 10 0, 10 11, 11 10, 0 10))") do
      expect(subject).to include("geometry")
      expect(subject['geometry']).to eq('MULTIPOLYGON (((10 0,10 10,0 10,0 0,10 0)),((11 10,10 11,10 10,11 10)))')
    end
  end
end
