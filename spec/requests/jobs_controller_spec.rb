require "rails_helper"

describe JobsController do
  describe "similar_jobs" do
    it "should return similar jobs" do
      root_job = Job.create(uid: 1, dev_type: 2)
      recommended_job = Job.create(uid: 2, title: "recommended title", dev_type: 2)
      applicant = User.create(uid: "1")
      current_user = User.create(uid: "2")

      current_user.jobs << root_job

      applicant.jobs << root_job
      applicant.jobs << recommended_job

      get similar_jobs_job_url(root_job.uid, user_uid: current_user.uid)

      parsed_response = JSON.parse(response.body)
      parsed_response.first.first["job"].delete("id")
      expect(parsed_response).to eq(
        [
          [
            {
              "job" => {
                "uid" => 2,
                "title"=> "recommended title",
                "dev_type"=> 2,
                "deleted" => false
              }
            },
            1, # score
            1 # application_count
          ]
        ]
      )
    end
  end
end
