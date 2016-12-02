require "rails_helper"

describe JobApplication do
  describe ".import" do
    it "should create an APPLIED_TO relation from data from copro" do
      job = Job.create(uid: 3)
      applicant = User.create(uid: 2)
      user = User.create(uid: 5)

      JobApplication.import_model({
        job_id: 3,
        user_uid: 2
      })

      expect(applicant.jobs).to include(job)
      expect(job.applicants).to include(applicant)
      expect(job.applicants).not_to include(user)
    end
  end
end
