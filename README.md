# fluent-plugin-bwlist

fluent-plugin-bwlist is a record filter plugin using black/white list.

## Installation

### RubyGems

```
$ gem install fluent-plugin-bwlist
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-bwlist"
```

And then execute:

```
$ bundle
```

## Example

conf:

```
<filter **>
  @type bwlist
  s3_bucket sample-bucket-name
  s3_key bwlist.txt
  key id
  mode blacklist
</filter>
```

list(Newline-delimited):

```txt
1
3
5
...
```

## Configuration

### s3_bucket (string) (required)

S3 bucket name

### s3_key (string) (required)

S3 path

### key (string) (required)

filtering target key name

### mode (enum) (optional)

Select black/white filtering mode

## Copyright

* Copyright(c) 2018- kei_q
* License
  * Apache License, Version 2.0
