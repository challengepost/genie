module Concerns
  module Import
    extend ActiveSupport::Concern

    module ClassMethods
      def import_model(message)
        # override in model
      end

      def import(message)
        if message[:batch].present?
          import_batch(message[:batch])
        else
          import_model(message)
        end
      end

      def import_batch(batch)
        batch.each { |message| import_model(message) }
      end
    end
  end
end
