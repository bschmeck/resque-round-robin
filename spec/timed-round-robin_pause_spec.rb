require "spec_helper"

describe "TimedRoundRobin" do

  before(:each) do
    Resque.redis.flushall
  end

  context "a worker" do
    it "does not switch queues when one is excluded and a slice expires" do
      Resque.redis.set('paused_queues', ['q1'])
      5.times { Resque::Job.create(:q1, SomeJob) }
      5.times { Resque::Job.create(:q2, SomeJob) }

      worker = Resque::Worker.new(:q1, :q2)

      worker.process
      expect(Resque.size(:q2)).to eq 4

      worker.process
      expect(Resque.size(:q2)).to eq 3

      Timecop.travel(Time.now + 60) do
        worker.process
        expect(Resque.size(:q2)).to eq 2
      end
    end
  end
end
