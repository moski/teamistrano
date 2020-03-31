require_relative 'messaging/base'
require 'net/http'
require 'json'
require 'forwardable'

load File.expand_path("../tasks/teams.rake", __FILE__)

module Teamistrano
  class Capistrano

    attr_reader :backend
    private :backend

    extend Forwardable
    def_delegators :env, :fetch, :run_locally

    def initialize(env)
      @env = env
      config = fetch(:teamistrano, {})
      @messaging = if config
                     opts = config.dup.merge(env: @env)
                     klass = opts.delete(:klass) || Messaging::Default
                     klass.new(opts)
                   else
                     Messaging::Null.new
                   end
    end

    def run(action)
      _self = self
      run_locally { _self.process(action, self) }
    end

    def process(action, backend)
      @backend = backend

      payload = @messaging.payload_for(action)
      return if payload.nil?

      # payload = {
      #   username: @messaging.username,
      #   icon_url: @messaging.icon_url,
      #   icon_emoji: @messaging.icon_emoji,
      # }.merge(payload)

      channels = Array(@messaging.channels_for(action))
      if channels.empty?
        channels = [nil] # default webhook channel
      end
      
      channels.each do |channel|
        post(payload.merge(channel: channel))
      end
    end

    private ##################################################

    def post(payload)

      if dry_run?
        post_dry_run(payload)
        return
      end

      #begin
        response = post_to_teams(payload)
      # rescue => e
      #   backend.warn("[teamistrano] Error notifying MS Teams!")
      #   backend.warn("[teamistrano]   Error: #{e.inspect}")
      # end

      # if response && response.code !~ /^2/
      #   warn("[teamistrano] MS Teams API Failure!")
      #   warn("[teamistrano]   URI: #{response.uri}")
      #   warn("[teamistrano]   Code: #{response.code}")
      #   warn("[teamistrano]   Message: #{response.message}")
      #   warn("[teamistrano]   Body: #{response.body}") if response.message != response.body && response.body !~ /<html/
      # end
    end

    def post_to_teams(payload = {})
      post_to_teams_as_webhook(payload)
    end

    def post_to_teams_as_webhook(payload = {})
      params =  payload.to_json
      
      puts params.inspect
      
      uri = URI(@messaging.webhook)
      Net::HTTP.post_form(uri, params)
    end

    def dry_run?
      ::Capistrano::Configuration.env.dry_run?
    end

    def post_dry_run(payload)
      backend.info("[teamistrano]   Webhook: #{@messaging.webhook}")
    end
  end
end
