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

      job_query = job.query_as(:job).
        # match Jobs users who applied to the given job also applied to
        match("(job:Job) <-[:APPLIED_TO]- (similarUser:User) -[:APPLIED_TO]-> (recommendedJob:Job)")

        if user.present?
          job_query = job_query.
            match(currentUser: { User: { uid: user.uid.to_s } }).
            where_not("(currentUser) -[:APPLIED_TO]-> (recommendedJob)")
        end

        job_query = job_query.
          order("score DESC").
          limit(limit).
          pluck("recommendedJob, COUNT(DISTINCT(similarUser)) as score")
    end
  end
end
