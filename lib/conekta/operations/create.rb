module Conekta
  module Operations
    module Create
      module ClassMethods
        def create(params, _api_key = nil)
          _url = Util.types[self.class_name.downcase]._url
          response = Requestor.new(_api_key).request(:post, _url, params)
          instance = self.new
          instance.set_api_key(_api_key) if _api_key
          instance.load_from(response)
          instance
        end
      end
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
