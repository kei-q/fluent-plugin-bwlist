#
# Copyright 2018- kei_q
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "fluent/plugin/filter"

require 'aws-sdk-s3'

module Fluent
  module Plugin
    class BWlistFilter < Fluent::Plugin::Filter
      Fluent::Plugin.register_filter("bwlist", self)

      config_param :key, :string,
                   desc: "target key"

      config_param :s3_bucket, :string,
                   desc: 'config bucket'

      config_param :s3_key, :string,
                   desc: 'config key'

      config_param :mode, :enum, list: [:blacklist, :whitelist], default: :blacklist,
                   desc: 'select mode blacklist/whitelist'

      def configure(conf)
        super

        @mode_bool = conf['mode'] == 'blacklist'
      end

      def start
        super

        @list = fetch_list(@s3_bucket, @s3_key)
        log.debug "filter_bwlist:: list_encoding:#{@list.map(&:encoding)}"
        log.info "filter_bwlist:: s3:#{@s3_bucket}/#{@s3_key} key:#{@key} list_size:#{@list.length}"
        log.debug "filter_bwlist:: list:#{@list}"
      end

      def filter(tag, time, record)
        log.debug "filter_bwlist:: record:#{record[@key].to_s} record_encoding:#{record[@key].encoding}"
        log.debug "filter_bwlist:: check:#{@list.include?(record[@key].to_s)}"
        @list.include?(record[@key].to_s) ^ @mode_bool ? record : nil
      # NOTE: explicit rescue
      # If omit this code under filter chain optimization, cause unexpected record emittion
      rescue => e
        filter.router.emit_error_event(tag, time, record, e)
        nil
      end

      private

      def fetch_list(bucket, key)
        # return File.readlines('./testfile.txt', chomp:true, encoding: 'UTF-8:UTF-8')
        s3_client = Aws::S3::Client.new
        resp = s3_client.get_object(bucket: bucket, key: key)
        resp.body.set_encoding('UTF-8', 'UTF-8').readlines(chomp: true)
      end
    end
  end
end
