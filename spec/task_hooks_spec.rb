require 'spec_helper'

describe Teamistrano do

  describe "before/after hooks" do

    it "invokes teams:deploy:starting before deploy:starting" do
      expect(Rake::Task['deploy:starting'].prerequisites).to include 'teams:deploy:starting'
    end

    it "invokes teams:deploy:updating before deploy:updating" do
      expect(Rake::Task['deploy:updating'].prerequisites).to include 'teams:deploy:updating'
    end

    it "invokes teams:deploy:reverting before deploy:reverting" do
      expect(Rake::Task['deploy:reverting'].prerequisites).to include 'teams:deploy:reverting'
    end

    it "invokes teams:deploy:updated after deploy:finishing" do
      expect(Rake::Task['teams:deploy:updated']).to receive(:invoke)
      Rake::Task['deploy:finishing'].execute
    end

    it "invokes teams:deploy:reverted after deploy:finishing_rollback" do
      expect(Rake::Task['teams:deploy:reverted']).to receive(:invoke)
      Rake::Task['deploy:finishing_rollback'].execute
    end

    it "invokes teams:deploy:failed after deploy:failed" do
      expect(Rake::Task['teams:deploy:failed']).to receive(:invoke)
      Rake::Task['deploy:failed'].execute
    end

    it "invokes all teams:deploy tasks before teams:deploy:test" do
      expect(Rake::Task['teams:deploy:test'].prerequisites).to match %w[starting updating updated reverting reverted failed]
    end
  end

end
