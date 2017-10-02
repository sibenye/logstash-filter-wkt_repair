# WKT Repair Logstash Filter

Repairs WKTs on a Logstash event that are ambigous or ill-defined polygons and returns a coherent and clearly defined output.

Examples of ambigous or ill-defined polygons include, but not limited to:

* A polygon with dangling edge
* A polygon that is not closed
* A polygon that  self intersects

## Config example
```javascript
{
    ...
    filter {
        wkt_repair {
            source => "wkt"
            target => "wkt_repaired"
            tag_on_failure => [ "_wkt_repair_failure" ]
        }
    }
    ...
}
```

## Dependencies

Yeah, unfortunately, this plugin depends on your server/container having these installed;
- [cmake](https://cmake.org/download/)
- [prepair](https://github.com/ForRentCom/prepair)

### Dependency installation
Run the following commands to install the dependencies;

Installing cmake:
```sh
wget https://cmake.org/files/v3.9/cmake-3.9.3.tar.gz
tar xzf cmake-3.9.3.tar.gz
cd cmake-2.8.3
./configure --prefix=/opt/cmake
make
make install
```
Add `/opt/cmake/bin` to your $PATH

Installing prepair:
```sh
wget https://github.com/ForRentCom/prepair/archive/master.zip
unzip prepair-master.zip -d /opt
mv /opt/prepair-master /opt/prepair
cd /opt/prepair
cmake .
make
```
Add `/opt/prepair` to your $PATH

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.
```sh
rvm install jruby
jruby -S gem install bundler
```

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

### 2. Installing and Running the plugin locally

- Build the plugin gem
```sh
gem build logstash-filter-wkt_repair.gemspec
```
- Install the plugin from the Logstash home
```sh
bin/logstash-plugin install /your/local/plugin/logstash-filter-wkt_repair.gem
```
- Start Logstash and proceed to using/testing the plugin

For walk through of developing Logstash filter plugin see https://www.elastic.co/guide/en/logstash/current/_how_to_write_a_logstash_filter_plugin.html
