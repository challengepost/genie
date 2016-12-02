class JobsController < ApplicationController
  # before_action :authorize!

  before_action :find_user
  before_action :find_job

  attr_accessor :user, :job

  def index
  end

  def similar_jobs
    render json: recommended_jobs.to_json
  end

  private

  def recommended_jobs
    Recommendations::Job.new(job).
      for(user).
      similar_jobs(limit)
  end

  def find_job
    self.job = Job.find_by(uid: params[:id].to_i)
  end

  def find_user
    self.user = User.find_by(uid: params[:user_uid])
  end

  def limit
    params[:limit].to_i
  end
end
