namespace :teams do
  namespace :deploy do

    desc 'Notify about starting deploy'
    task :starting do
      Teamistrano::Capistrano.new(self).run(:starting)
    end

    desc 'Notify about updating deploy'
    task :updating do
      Teamistrano::Capistrano.new(self).run(:updating)
    end

    desc 'Notify about reverting deploy'
    task :reverting do
      Teamistrano::Capistrano.new(self).run(:reverting)
    end

    desc 'Notify about updated deploy'
    task :updated do
      Teamistrano::Capistrano.new(self).run(:updated)
    end

    desc 'Notify about reverted deploy'
    task :reverted do
      Teamistrano::Capistrano.new(self).run(:reverted)
    end

    desc 'Notify about failed deploy'
    task :failed do
      Teamistrano::Capistrano.new(self).run(:failed)
    end

    desc 'Test TEAMS integration'
    task :test => %i[starting updating updated reverting reverted failed] do
      # all tasks run as dependencies
    end

  end
end

before 'deploy:starting',           'teams:deploy:starting'
before 'deploy:updating',           'teams:deploy:updating'
before 'deploy:reverting',          'teams:deploy:reverting'
after  'deploy:finishing',          'teams:deploy:updated'
after  'deploy:finishing_rollback', 'teams:deploy:reverted'
after  'deploy:failed',             'teams:deploy:failed'
