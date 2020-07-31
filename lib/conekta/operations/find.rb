module Conekta
  module Operations
    module Find
      module ClassMethods
        def find(id, _api_key = nil)
          instance = self.new(id)
          instance.set_api_key(_api_key) if _api_key
          response = Requestor.new(_api_key).request(:get, instance._url)
          instance.load_from(response)
          instance
        end

        # <b>DEPRECATED:</b> Please use <tt>find</tt> instead.
        alias_method :retrieve, :find
      end
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
