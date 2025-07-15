require 'json'
require 'jwt'
require 'net/http'
require 'securerandom'
require 'time'

require 'axm/client/organization_devices'
require 'axm/client/mdm_servers'

module Axm
  class Client
    include MdmServers
    include OrganizationDevices

    # Initializes a new instance of the AXM client.
    #
    # @param private_key [String] The private key used for authentication.
    # @param client_id [String] The client identifier.
    # @param key_id [String] The key identifier.
    # @param api_domain [String, nil] Optional custom API domain.
    def initialize(private_key:, client_id:, key_id:, api_domain: nil)
      @private_key = OpenSSL::PKey::EC.new(private_key)
      @client_id = client_id
      @key_id = key_id
      @api_domain = api_domain
    end

    # Determines the scope based on the client_id prefix.
    #
    # @return [String] The scope, either 'business' or 'school'.
    # @raise [ArgumentError] If the client_id prefix is unknown.
    def scope
      @scope ||=
        case @client_id.split('.').first
        when 'BUSINESSAPI'
          'business'
        when 'SCHOOLAPI'
          'school'
        else
          raise ArgumentError, "Unknown client_id prefix: #{@client_id.split('.').first}"
        end
    end

    # Determines the API endpoint based on the current scope.
    #
    # @return [String] The API domain for the given scope.
    # @raise [ArgumentError] If the scope is unknown.
    def api_domain
      case scope
      when 'business'
        'api-business.apple.com'
      when 'school'
        'api-school.apple.com'
      else
        raise ArgumentError, "Unknown scope: #{scope}"
      end
    end

    def client_assertion
      @client_assertion ||= begin
        audience = 'https://account.apple.com/auth/oauth2/v2/token'
        algo = 'ES256'

        issued_at_timestamp = Time.now.utc.to_i
        expiration_timestamp = issued_at_timestamp + 86_400 * 180 # 180 days

        payload = {
          sub: @client_id,
          aud: audience,
          iat: issued_at_timestamp,
          exp: expiration_timestamp,
          jti: SecureRandom.uuid,
          iss: @client_id
        }

        JWT.encode(payload, @private_key, algo, kid: @key_id)
      end
    end

    def access_token
      cached_access_token = JSON.parse(Secret.read('stub_access_token')) if File.exist?('secrets/stub_access_token')

      if cached_access_token
        token_expiration = Time.parse(cached_access_token['expires_at'])
        token_expired = Time.now.utc >= token_expiration

        return cached_access_token unless token_expired
      end

      params = {
        grant_type: 'client_credentials',
        client_id: @client_id,
        client_assertion_type: 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer',
        client_assertion: client_assertion,
        scope: "#{scope}.api"
      }

      response = post('https://account.apple.com/auth/oauth2/v2/token', params)

      response_body = response.first if response.last.to_i == 200

      token = response_body.merge!({ 'expires_at' => Time.now.utc + response_body['expires_in'] })

      Secret.write('stub_access_token', token.to_json)

      response_body
    end

    # Sends a GET request to the specified API endpoint.
    #
    # @param path [String] The API endpoint to request.
    # @param options [Hash] Query parameters and special options:
    #   - :paginate [Boolean] Whether to paginate through all results (unused).
    #   - :fields [Array<String>] Optional fields to include as fields[orgDevices].
    # @return [Hash] The parsed JSON response.
    def get(path, options = {})
      options = options.dup

      endpoint = path.split('/').last

      fields_key = options.delete(:fields_key) || endpoint

      fields = options.delete(:fields)
      options["fields[#{fields_key}]"] = fields.join(',') if fields

      uri = URI("https://#{api_domain}/#{path}")
      uri.query = URI.encode_www_form(options) unless options.empty?

      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = "Bearer #{access_token['access_token']}"

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }

      raise "API request failed: #{res.code} #{res.message}" unless res.is_a?(Net::HTTPSuccess)
      raise "Unauthorized: Invalid or expired access token (HTTP #{res.code})" if res.is_a?(Net::HTTPUnauthorized)

      JSON.parse(res.body)
    end

    # Sends a POST request to the specified URI with given parameters.
    #
    # @param uri [String, URI] The endpoint URI.
    # @param params [Hash] Parameters to include in the request body.
    # @return [Net::HTTPResponse] The HTTP response object.
    def post(uri, params = {})
      uri = URI(uri) if uri.is_a?(String)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'

      request = Net::HTTP::Post.new(uri)
      request['Host'] = uri.host
      request['Content-Type'] = 'application/x-www-form-urlencoded'
      request.body = URI.encode_www_form(params) unless params.empty?

      response = http.request(request)

      raise 'Too many requests' if response.code == '429'

      response_json = JSON.parse(response.body)

      raise 'Invalid request' if response_json['error'] == 'invalid_request'

      [response_json, response.code]
    end
  end
end
