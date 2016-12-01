class JobsController < ApplicationController
  # before_action :authorize!

  before_action :find_job

  attr_accessor :job

  def similar_jobs
    render json: similar_jobs.to_json
  end

  private

  def similar_jobs
    Recommendations::Job.new(job).
      for(current_neo_user).
      similar_jobs(limit)
  end

  def find_job
    self.job = Job.find_by(uid: params[:id].to_i)
  end

  def limit
    params[:limit].to_i
  end
end
