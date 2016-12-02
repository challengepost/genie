require "rails_helper"

describe Recommendations::Job do
  # job we want to find similar jobs for
  let(:root_job) { Job.create(uid: 1337) }

  # user who just applied to root_job
  let(:current_user) { User.create(uid: "1") }

  subject { Recommendations::Job.new(root_job).for(current_user) }

  describe "#similar_jobs" do
    # http://i.imgur.com/CSd6yoK.jpg
    it "should recommend jobs which received applications from users who applied to the given job" do
      # These 2 applied to the root job
      applicant_1 = User.create(uid: "2")
      applicant_2 = User.create(uid: "3")

      # this applicant applied to a recommended job, but not the root_job
      random_applicant = User.create(uid: "4")

      # applicant_1, applicant_2 and random_applicant applied to it
      first_job = Job.create(uid: 1)
      # applicant_1 and applicant_2 applied to it
      second_job = Job.create(uid: 2)
      # only applicant_1 applied to it
      third_job = Job.create(uid: 3)
      # not recommended because the current user already applied to it
      excluded_job = Job.create(uid: 4)
      # not be recommended because none of the given job applicants also applied to it

      # Setting up the APPLIED_TO relationships
      current_user.jobs << root_job
      applicant_1.jobs << root_job
      applicant_2.jobs << root_job

      [applicant_1, applicant_2, random_applicant].each do |applicant|
        first_job.applicants << applicant
      end

      [applicant_1, applicant_2].each do |applicant|
        second_job.applicants << applicant
      end

      [current_user, applicant_1, applicant_2].each do |applicant|
        excluded_job.applicants << applicant
      end

      third_job.applicants << applicant_1

      # Finding the similar jobs
      similar_jobs = subject.similar_jobs(5)
      similar_job_ids = similar_jobs.map { |job| job.first.uid }

      expect(similar_job_ids).to match([1, 2, 3])
    end
  end
end
