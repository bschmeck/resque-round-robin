require "spec_helper"

describe "TimedRoundRobin" do

  before(:each) do
    Resque.redis.flushall
  end

  context "a worker" do
    it "switches queues, round robin" do
      5.times { Resque::Job.create(:q1, SomeJob) }
      5.times { Resque::Job.create(:q2, SomeJob) }

      worker = Resque::Worker.new(:q1, :q2)

      worker.process
      expect(Resque.size(:q1)).to eq 5
      expect(Resque.size(:q2)).to eq 4

      worker.process
      expect(Resque.size(:q1)).to eq 4
      expect(Resque.size(:q2)).to eq 4
    end

    it 'skips a queue that is being processed by another worker'
  end

  it "should pass lint" do
    Resque::Plugin.lint(Resque::Plugins::TimedRoundRobin)
  end

end
