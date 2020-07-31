module Conekta
  class Resource < ConektaObject

    attr_accessor :id

    def initialize(id=nil)
      @id = id
      super()
    end

    def self._url()
      "/#{CGI.escape(underscored_class)}s"
    end

    def _url
      ensure_id

      return [self.class._url, id].join('/')
    end

    def self.underscored_class
      Conekta::Util.underscore(self.to_s)
    end

    def create_member_with_relation(member, params, parent)
      parent_klass = parent.class.underscored_class
      api_key = parent.api_key if parent.api_key
      child = self.create_member(member, params, api_key)
      child.create_attr(parent_klass.to_s, parent)
      child.set_api_key(api_key) if api_key
      return child
    end

    private
    def ensure_id
      if (id.nil? || id.to_s.empty?)
        exception = Error.error_handler({
          "details" => [{
            "debug_message" => I18n.translate(
              'error.resource.id',
              locale: :en,
              resource: self.class.class_name
            ),
            "message" => I18n.translate(
              'error.resource.id_purchaser',
              locale: Conekta.locale.to_sym
            ),
            "param" => "id",
            "code" => "error.resource.id"
          }]
        }, -2)

        raise exception
      end
    end
  end
end
