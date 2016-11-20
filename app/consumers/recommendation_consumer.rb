class RecommendationConsumer
  include Hutch::Consumer

  consume "copro.recommendations.sync.*"

  def process(message)
    model = message.routing_key.split(".").last.classify.constantize
    model.import(message)
  rescue NameError => e
    raise UnsupportedModelError, "#{self.class.name} error - #{e.message}: #{message}"
  end
end
