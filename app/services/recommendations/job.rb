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
        # match all the applications to recommended jobs,
        # so that we can order them by application count
        match("(recommendedJob) <-[applications:APPLIED_TO]- ()").
        # recommended jobs' role has to be the same as the given job
        where("recommendedJob.dev_type" => job.dev_type).
        # makes sure we don't recommend the given job
        where_not("recommendedJob.uid" => job.uid).
        # deleted jobs can be useful for other recommendations
        # (as links between other entities), but not here.
        where("recommendedJob.deleted <> true OR NOT EXISTS(recommendedJob.deleted)")

        if user.present?
          # excludes the jobs the user applied to
          job_query = job_query.where_not(
            "(:User { uid: '#{user.uid}' }) -[:APPLIED_TO]-> (recommendedJob)"
          )
        end

        job_query = job_query.
          order(
            # The score of a job is the number of people who applied to both
            # this job and the given job.
            "score DESC",
            # The application_count is the total number of application a job received,
            # used to separate jobs with the same score.
            "application_count DESC"
          ).
          limit(limit).
          pluck(
            "recommendedJob",
            "COUNT(DISTINCT(similarUser)) as score",
            "COUNT(DISTINCT(applications)) as application_count"
          )
    end
  end
end
