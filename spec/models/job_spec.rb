require "rails_helper"

describe Job do
  describe ".import" do
    it "should create a job from data from copro" do
      Job.import_model({
        id: 1,
        title: "Hello",
        dev_type: 2,
        state: "draft"
      })

      job = Job.last
      expect(job.uid).to eq 1
      expect(job.title).to eq "Hello"
      expect(job.dev_type).to eq 2
      expect(job.state).to eq "draft"
    end

    it "should update a job from data from copro" do
      Job.create(uid: 1, title: "Title 1", dev_type: 2, state: "published_publicly")

      Job.import_model({
        id: 1,
        title: "Title 2",
        dev_type: 3,
        state: "draft"
      })

      expect(Job.count).to eq 1

      job = Job.last
      expect(job.uid).to eq 1
      expect(job.title).to eq "Title 2"
      expect(job.dev_type).to eq 3
      expect(job.dev_type).to eq "draft"
    end
  end

  describe ".remove_model" do
    it "should mark the job as deleted" do
      job = Job.create(uid: 1, title: "Title 1", dev_type: 2)
      expect(job).not_to be_deleted

      Job.remove_model({ id: 1 })

      expect(Job.count).to eq(1)
      job = Job.last
      expect(job).to be_deleted
    end
  end
end
