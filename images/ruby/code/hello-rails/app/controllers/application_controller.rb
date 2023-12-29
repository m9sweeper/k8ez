class ApplicationController < ActionController::Base
  before_action :log_request_info

  def log_request_info
    Rails.logger.info "#{'-' * 30} #{Time.now.in_time_zone('America/Chicago').strftime('%m-%d-%Y %I:%M%p %Z')} #{'-' * 30}"
    Rails.logger.info "From: #{request.ip}"
    Rails.logger.info "#{request.method} #{request.original_url}"
    Rails.logger.info "#{request.controller_class}##{action_name}"
    Rails.logger.info request.params.to_s
    Rails.logger.info ('-' * 85).to_s
  end
end
