module Axm
  class Client
    def initialize(token: nil, org_type: nil, api_endpoint: nil)
      raise ArgumentError, "Provide the token argument" if token.nil?

      if (org_type.nil? && api_endpoint.nil?) || (org_type != "business" && org_type != "school")
        raise ArgumentError,
              "Provide a valid org_type argument ('business' for Apple Business Manager or 'school' for Apple School Manager) or the api_endpoint argument for your environment"
      end

      if org_type && api_endpoint
        raise ArgumentError,
              "Provide either a valid org_type or api_endpoint argument for your environment, not both"
      end

      @token = token
      @org_type = org_type
    end

    def api_endpoint
      @api_endpoint || "https://api-#{@org_type}.apple.com/api/v1"
    end
  end
end
