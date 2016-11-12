
require 'resque'
require 'resque/worker'
require 'resque-dynamic-queues'
require "resque/plugins/timed_round_robin/version"
require "resque/plugins/timed_round_robin/timed_round_robin"

Resque::Worker.send(:include, Resque::Plugins::TimedRoundRobin)
