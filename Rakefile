# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Secondkitchen::Application.load_tasks

task(:nightly => :environment) do
  settings = Setting.first
  # disable any users who are behind on workshare
  thresh = settings.num_months_under_disable
  Member.all.each{ |m|
    next if m.admin # admin can't have their account disabled
    under = m.consecutive_months_under_service 
    if under >= thresh and !m.disabled
      puts "#{m} workshare disabling"
      m.disabled = true
      m.auto_disabled_type = "workshare"
      m.disabled_reason = "#{under} consecutive months below workshare requirements."
      m.save
    elsif under < thresh and m.disabled and m.auto_disabled_type = "workshare"
      puts "#{m} workshare re-enabling"
      m.disabled = false
      m.save
    end
  }
  # generate fees, and penalize members for not paying them, as necessary
  Member.all.each{ |m|
    startup_fee = Fee.where("member_id=#{m.id} AND kind='startup'").first
    if startup_fee.nil?
      puts "#{m} startupfee creating"
      f = Fee.new
      f.amount = settings.startup_fee
      f.due = Date.today + settings.startup_fee_slack_days
      f.kind = "startup"
      f.member = m
      f.save
    else
      if !startup_fee.paid and startup_fee.due < Date.today and !m.disabled
        puts "#{m} startupfee disabling"
        m.disabled = true
        m.disabled_reason = "startup fee of ($#{startup_fee.amount}) hasn't been paid and was due #{startup_fee.due}"
        m.auto_disabled_type = "startupfee"
        m.save
      elsif startup_fee.paid and m.disabled and m.auto_disabled_type = "startupfee"
        puts "#{m} startupfee re-enabling"
        m.disabled = false
        m.save
      end
    end

    fees.each do |fee| 
      if !fee.paid && fee.due < Date.today
        puts "#{m} disabled from unpaid fee"
        m.disabled
        m.save
      end
    end
  
  }
end

