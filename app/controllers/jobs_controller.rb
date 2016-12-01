class JobsController < ApplicationController
  # before_action :authorize!

  before_action :find_user
  before_action :find_job

  attr_accessor :user, :job

  def similar_jobs
    jobs = Recommendations::Job.new(job).for(user).similar_jobs(params[:limit].to_i)
    render json: jobs.to_json
  end

  private

  def find_job
    self.job = Job.find_by(uid: params[:id].to_i)
  end

  def find_user
    self.user = nil
  end
end
