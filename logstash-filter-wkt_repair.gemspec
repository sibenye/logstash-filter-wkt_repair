Gem::Specification.new do |s|
  s.name          = 'logstash-filter-wkt_repair'
  s.version       = '0.1.10'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Logstash filter to repair a WKT shape data.'
  s.description   = 'It takes ambigous or ill-defined polygons and returns a coherent and clearly defined output.'
  s.homepage      = 'https://github.com/sibenye/logstash-filter-wkt_repair'
  s.authors       = ['Silver Ibenye']
  s.email         = 'sibenye@gmail.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", ">= 1.60", "<= 2.99"
  s.add_development_dependency 'logstash-devutils', '1.3.3'
end
