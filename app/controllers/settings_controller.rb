class SettingsController < ApplicationController
  before_filter :require_admin

  def edit
    @settings = Setting.first
    @pickup_dows = {}
    @settings.pickup_dows.split(/:/).each{ |v| @pickup_dows[v.to_i] = true } unless @settings.pickup_dows.nil?
    render :edit
  end

  def update
    params[:setting][:pickup_dows] = params[:pickup_dows].nil? ? nil : params[:pickup_dows].join(":")
    Setting.first.update_attributes(params[:setting])
    edit
  end
end
