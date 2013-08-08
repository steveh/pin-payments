module Pin
  class Repository

    def initialize(api)
      @api = api

      @klass = self.class.to_s.gsub(/Repository$/, "").constantize
    end

    def build(attributes = {})
      Card.new(attributes)
    end

    def create(options, path = api_path)
      response = authenticated_post(path, options)

      if response.status == 201 # object created
        build_instance_from_response(response)
      else
        raise Pin::APIError.new(response)
      end
    end

    def all(options = {})
      options = {path: api_path, page: 1}.merge(options)
      paging = "page=#{options[:page]}" unless options[:page] == 1

      response = authenticated_get(options[:path], paging)

      if response.status == 200
        build_collection_from_response(response)
      else
        raise Pin::APIError.new(response)
      end
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

      response = authenticated_get("#{options[:path]}/#{token}")

      if response.status == 200
        build_instance_from_response(response)
      else
        raise Pin::APIError.new(response)
      end
    end

  protected

    attr_reader :api, :klass

    def api_path
      "/1/#{klass.to_s.demodulize.underscore.pluralize}"
    end

    def authenticated_post(url, params = nil)
      api.connection.post(url, params)
    end

    def authenticated_get(url, params = nil)
      api.connection.get(url, params)
    end

    def build_instance(record)
      klass.new(api, record)
    end

    def build_instance_from_response(response)
      json = MultiJson.load(response.body)

      data = json['response']

      build_instance(data)
    end

    def build_collection_from_response(response)
      json = MultiJson.load(response.body)

      records = json['response'].collect do |data|
        build_instance(data)
      end

      pg = json['pagination']

      CollectionResponse.new(records, pg['per_page'], pg['pages'], pg['current'])
    end

  end
end
