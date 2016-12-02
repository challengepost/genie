module Recommendations
  class Job
    attr_accessor :job, :user

    def initialize(job)
      self.job = job
    end

    def for(user)
      self.user = user
      self
    end

    def similar_jobs(limit = 2)
      return [] unless job

      limit = 2 if limit <= 0

      job_query = job.query_as(:job).
        # match Jobs which received applications from users who also also applied to the given job
        match("(job:Job) <-[:APPLIED_TO]- (similarUser:User) -[:APPLIED_TO]-> (recommendedJob:Job)").
        break.
        # match all the applications to recommended jobs, so that we can order them by application count
        match("(recommendedJob) <-[applications:APPLIED_TO]- ()").
        where("recommendedJob.dev_type" => job.dev_type).
        where("recommendedJob.deleted <> true OR NOT EXISTS(recommendedJob.deleted)").
        where_not("recommendedJob.uid" => job.uid)

        if user.present?
          job_query = job_query.where_not("(:User { uid: \"#{user.uid}\" }) -[:APPLIED_TO]-> (recommendedJob)")
        end

        job_query = job_query.
          order("score DESC, application_count DESC").
          limit(limit).
          pluck("recommendedJob, COUNT(DISTINCT(similarUser)) as score, COUNT(DISTINCT(applications)) as application_count")
    end
  end
end
