module Resque
  class Worker

    # Returns an array of all worker objects currently processing jobs.
    def self.working
      puts "**** working"
      names = all
      return [] unless names.any?

      reportedly_working = data_store.working_keys(names)

      reportedly_working.map do |key|
        worker = find(key.sub("worker:", ''), :skip_exists => true)
        worker.job = { 'queue' => key.split(':').last }
        worker
      end.compact
    end
  end

  class DataStore
    def working_keys(worker_ids)
      puts "**** working_keys"
      redis_keys = worker_ids.map { |id| "worker:#{id}" }

      # pipeline our exists checks since there is no MEXISTS commmand.
      # more efficient as we don't need a round trip between each query.
      key_exists = @redis.pipelined { redis_keys.each { |k| @redis.exists(k) } }

      # this returns a [true, false, true] type array.
      # filter our original list for values where true was returned.
      result = redis_keys.zip(key_exists).map { |key, exists| key if exists }.compact
      puts "**** working_keys result = #{result.inspect}"
      result
    end

    def get_excluded_queues
      @redis.get('test_key')
    end
  end
end
