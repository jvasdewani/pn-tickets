class ReportsController < ApplicationController
  before_filter :require_login!

  def new
    @report = Report.new
  end

  def create
    @uuid = SecureRandom.uuid
    GenerateReport.perform_async params[:report], @uuid
  end
end
