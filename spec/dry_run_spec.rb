require 'spec_helper'

class DryRunMessaging < Teamistrano::Messaging::Default
  def channels_for(action)
    "testing"
  end
end

describe Teamistrano do
  before(:all) do
    set :teamistrano, { klass: DryRunMessaging }
  end

  %w[starting updating reverting updated reverted failed].each do |stage|
    it "does not post to MS Teams on teams:deploy:#{stage}" do
      allow_any_instance_of(Teamistrano::Capistrano).to receive(:dry_run?).and_return(true)
      expect_any_instance_of(Teamistrano::Capistrano).to receive(:post_dry_run)
      expect_any_instance_of(Teamistrano::Capistrano).not_to receive(:post_to_teams)
      Rake::Task["teams:deploy:#{stage}"].execute
    end
  end

end
