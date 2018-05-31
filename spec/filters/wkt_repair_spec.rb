# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/wkt_repair"

describe LogStash::Filters::WktRepair do
  describe "Successfully repair a WKT" do
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
      expect(subject.get('geometry')).to eq('MULTIPOLYGON (((10 0,10 10,0 10,0 0,10 0)),((11 10,10 11,10 10,11 10)))')
    end
  end
end

describe LogStash::Filters::WktRepair do
  describe "Successfully repair a GeoJson" do
    let(:config) do <<-CONFIG
      filter {
        wkt_repair {
          source => "geojson"
          target => "geojson"
          type => "GeoJson"
        }
      }
    CONFIG
    end

    sample("geojson" => "{\"type\":\"Polygon\",\"coordinates\":[[[0,0],[0,10],[10,0],[10,10],[0,0]]]}") do
      expect(subject).to include("geojson")
      expect(subject.get('geojson')).to eq('MULTIPOLYGON (((0 10,0 0,5 5,0 10)),((5 5,10 0,10 10,5 5)))')
    end
  end
end

describe LogStash::Filters::WktRepair do
  describe "Unsuccessfully repair a WKT" do
    let(:config) do <<-CONFIG
      filter {
        wkt_repair {
          source => "geometry"
          target => "geometry"
        }
      }
    CONFIG
    end

    sample("geometry" => "POLYGON((0 0, 10 0, 10 11, 11 10, 0 10") do
      expect(subject).to include("geometry")
      expect(subject.get('geometry')).to eq('POLYGON((0 0, 10 0, 10 11, 11 10, 0 10')
      expect(subject.get('tags')).to include("_data_repair_failure")
      
    end
  end
end

describe LogStash::Filters::WktRepair do
  describe "Ignore Nil WKT" do
    let(:config) do <<-CONFIG
      filter {
        wkt_repair {
          source => "geometry"
          target => "geometry"
        }
      }
    CONFIG
    end

    sample("geometry" => nil) do
      expect(subject).to include("geometry")
      expect(subject.get('geometry')).to be_nil
    end
  end
end
