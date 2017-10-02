# logstash-filter-wkt_repair

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.
```sh
rvm install jruby
jruby -S gem install bundler
```

- Create a new plugin or clone and existing from the GitHub [logstash-plugins](https://github.com/logstash-plugins) organization. We also provide [example plugins](https://github.com/logstash-plugins?query=example).

- Install dependencies
```sh
bundle install
```

#### Test

- Update your dependencies

```sh
bundle install
```

- Run tests

```sh
bundle exec rspec
```

### 2. Installing and Running your plugin locally

You can build the gem and install it using:

- Build your plugin gem
```sh
gem build logstash-filter-wkt_repair.gemspec
```
- Install the plugin from the Logstash home
```sh
bin/logstash-plugin install /your/local/plugin/logstash-filter-wkt_repair.gem
```
- Start Logstash and proceed to using/testing the plugin

### 3. Installing the plugin from rubyGems
- To install the plugin from rubyGems
```sh
bin/logstash-plugin install logstash-filter-wkt_repair.gem
```

For walk through of developing Logstash filter plugin see https://www.elastic.co/guide/en/logstash/current/_how_to_write_a_logstash_filter_plugin.html
