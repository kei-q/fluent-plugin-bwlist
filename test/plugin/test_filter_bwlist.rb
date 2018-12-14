require "helper"
require "fluent/plugin/filter_bwlist.rb"

class BWlistFilterTest < Test::Unit::TestCase
  setup do
    any_instance_of(Fluent::Plugin::BWlistFilter) do |klass|
      stub(klass).fetch_list {%w(1 3 5)}
    end

    Fluent::Test.setup
  end

  test "blacklist" do
    d = create_driver %[
      s3_bucket dummy-bucket
      s3_key list.txt
      key target_id
      mode blacklist
    ]

    d.run do
      d.feed('fluent.test', event_time, {'target_id'=>1})
      d.feed('fluent.test', event_time, {'target_id'=>2})
    end

    filtered_records = d.filtered_records
    assert_equal(1, filtered_records.size)
    assert_equal(2, filtered_records.first['target_id'])
  end

  test "whitelist" do
    d = create_driver %[
      s3_bucket dummy-bucket
      s3_key list.txt
      key target_id
      mode whitelist
    ]

    d.run do
      d.feed('fluent.test', event_time, {'target_id'=>1})
      d.feed('fluent.test', event_time, {'target_id'=>2})
    end

    filtered_records = d.filtered_records
    assert_equal(1, filtered_records.size)
    assert_equal(1, filtered_records.first['target_id'])
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::BWlistFilter).configure(conf)
  end
end
