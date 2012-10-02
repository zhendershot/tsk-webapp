# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Secondkitchen::Application.load_tasks

task(:disable => :environment) do
  thresh = Setting.first.num_months_under_disable
  Member.all.each{ |m|
    next if m.disabled
    under = m.consective_months_under_service 
    if under >= thresh
      m.disabled = true
      m.disabled_reason = "#{under} consecutive months below workshare requirements."
      m.save
    end
  }
end

