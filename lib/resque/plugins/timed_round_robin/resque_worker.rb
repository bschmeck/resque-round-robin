module Resque
  class Worker
    # Returns an array of all worker objects currently processing jobs.
    def self.working
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
      redis_keys = worker_ids.map { |id| "worker:#{id}" }
      redis_keys.select { |k| @redis.exists(k) }
    end
  end
end
