require 'spec_helper'

class NilPayloadMessaging < Teamistrano::Messaging::Default
  def payload_for_updating
    nil
  end

  def channels_for(action)
    "testing"
  end
end

describe Teamistrano do
  before(:all) do
    set :teamistrano, { klass: NilPayloadMessaging }
  end

  it "does not post on updating" do
    expect_any_instance_of(Teamistrano::Capistrano).not_to receive(:post)
    Rake::Task["teams:deploy:updating"].execute
  end

  it "posts on updated" do
    expect_any_instance_of(Teamistrano::Capistrano).to receive(:post).and_return(true)
    Rake::Task["teams:deploy:updated"].execute
  end
end
