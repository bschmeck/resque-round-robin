module Resque::Plugins
  module TimedRoundRobin
    class Configuration
      attr_accessor :queue_depths, :queue_refresh_interval

      def initialize
        @queue_depths = {}
        @queue_refresh_interval = 60
      end
    end
  end
end
