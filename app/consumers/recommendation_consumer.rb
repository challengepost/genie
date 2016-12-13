class RecommendationConsumer
  include Hutch::Consumer

  consume "copro.recommendations.*.*"

  def process(message)
    action, model_name = message.routing_key.split(".").last(2)
    model_class = model_name.classify.constantize

    case action
    when "sync"
      model_class.import(message)
    when "remove"
      model_class.remove(message)
    end
  rescue NameError => e
    raise UnsupportedModelError, "#{self.class.name} error - #{e.message}: #{message}"
  end
end
