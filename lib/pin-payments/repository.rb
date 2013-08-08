module Pin
  class Repository

    include HTTParty

    def initialize(api)
      @api = api
      @klass = self.class.to_s.gsub(/Repository$/, "").constantize

      self.class.base_uri api.base_uri
    end

    def build(attributes = {})
      Card.new(attributes)
    end

    def create(options, path = api_path)
      response = authenticated_post(path, options)

      if response.code == 201 # object created
        build_instance_from_response(response)
      else
        raise Pin::APIError.new(response)
      end
    end

    def all(options = {})
      options = {path: api_path, page: 1}.merge(options)
      paging = "page=#{options[:page]}" unless options[:page] == 1
      build_collection_from_response(authenticated_get(options[:path], paging))
    end

    def all_pages(options = {})
      options = options.merge(path: api_path)
    end

    def first(options = {})
      all(options).first
    end

    def last(options = {})
      all(options).last
    end

    def find(token, options = {})
      options = options.merge(path: api_path)
      build_instance_from_response(authenticated_get("#{options[:path]}/#{token}"))
    end

  protected

    attr_reader :api, :klass

    def api_path
      "/#{klass.to_s.demodulize.underscore.pluralize}"
    end

    def authenticated_post(url, body)
      self.class.post(url, body: body, basic_auth: api.auth)
    end

    def authenticated_get(url, query = nil)
      self.class.get(url, query: query, basic_auth: api.auth)
    end

    def build_instance(model)
      klass.new(api, model)
    end

    def build_instance_from_response(response)
      build_instance(response.parsed_response['response'])
    end

    def build_collection_from_response(response)
      models = []
      if response.code == 200
        response.parsed_response['response'].each do |model|
          models << build_instance(model)
        end
      end
      pg = response.parsed_response['pagination']
      CollectionResponse.new(models, pg['per_page'], pg['pages'], pg['current'])
    end

  end
end
