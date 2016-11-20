class Job
  include Neo4j::ActiveNode

  property :uid, constraint: :unique
  property :title

  has_many :in, :applicants, type: "APPLIED_TO",
    model_class: "User"

  def self.import(message)
    job = find_or_create(uid: message[:id])
    job.title = message[:title]
    job.save
  end
end
