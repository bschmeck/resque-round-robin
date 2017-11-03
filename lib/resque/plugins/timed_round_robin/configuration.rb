module Resque::Plugins
  module TimedRoundRobin
    class Configuration
      attr_accessor :queue_depths

      def initialize
        @queue_depths = {}
      end
    end
  end
end
