module Conekta
  module Operations
    module Where

      def self.handle_type_of_paging(response, class_name, params)
        if response.kind_of?(Hash) && response["object"] == "list"
          List.new(class_name, params)
        else
          ConektaObject.new
        end
      end

      module ClassMethods
        def where(params = nil, _api_key = nil)
          _url = Util.types[self.class_name.downcase]._url
          response = Requestor.new(_api_key).request(:get, _url, params)
          instance = ::Conekta::Operations::Where.handle_type_of_paging(response, self.class_name, params)
          instance.set_api_key(_api_key) if _api_key
          instance.load_from(response)
          instance
        end

        # <b>DEPRECATED:</b> Please use <tt>where</tt> instead.
        alias_method :all, :where
      end
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
