module Axm
  class Client
    module MdmServers
      # Retrieves a list of MDM servers associated with the organization.
      #
      # @param options [Hash] Optional query parameters to filter fields or paginate results.
      #   - fields: (Array) Array of fields to include in the response.
      #   - limit: (Integer) Maximum number of devices to return per page (default: 100, maximum: 1000).
      # @return [Array<Hash>] An array of MDM servers.
      #
      # See: https://developer.apple.com/documentation/applebusinessmanagerapi/get-mdm-servers
      # See: https://developer.apple.com/documentation/appleschoolmanagerapi/get-mdm-servers
      def list_mdm_servers(options = {})
        get("v1/mdmServers", options)
      end
    end
  end
end
