class User
  include Concerns::Import
  include Neo4j::ActiveNode

  property :uid, constraint: :unique
  property :screen_name

  has_many :out, :jobs, rel_class: :JobApplication

  def self.import_model(message)
    user = find_or_create(uid: message[:uid])
    user.screen_name = message[:screen_name]
    user.save
  end

  def provider_key
    ["devpost", uid.to_i]
  end
end
