require "helper"
require "fluent/plugin/filter_bwlist.rb"

class BwlistFilterTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::BwlistFilter).configure(conf)
  end
end
