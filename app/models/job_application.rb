class JobApplication
  include Concerns::Import
  include Neo4j::ActiveRel

  from_class :User
  to_class :Job
  type 'APPLIED_TO'

  def self.import_model(message)
    job = Job.find_by(uid: message[:job_id])
    user = User.find_by(uid: message[:user_uid])

    return unless job && user

    user.jobs << job
  end
end
