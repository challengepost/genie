class Job
  include Concerns::Import
  include Neo4j::ActiveNode

  property :uid, constraint: :unique
  property :title
  property :dev_type
  property :deleted, default: false

  has_many :in, :applicants, type: "APPLIED_TO",
    model_class: "User"

  def self.import_model(message)
    job = find_or_create_by(uid: message[:id])
    job.update(
      title: message[:title],
      dev_type: message[:dev_type]
    )
  end

  def self.remove_model(message)
    job = find_by(uid: message[:id])
    return unless job
    job.deleted = true
    job.save
  end
end
