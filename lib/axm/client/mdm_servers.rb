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

      # Retrieves a list of IDs for the devices assigned to a specific MDM server.
      #
      # @param mdm_server_id [String] The unique identifier of the MDM server.
      # @param options [Hash] Optional query parameters to paginate results or increase number of returned results.
      #   - limit: (Integer) Maximum number of devices to return per page (default: 100, maximum: 1000).
      # @return [Array<Hash>] An array of device IDs assigned to the specified MDM server.
      #
      # See: https://developer.apple.com/documentation/applebusinessmanagerapi/get-all-device-ids-for-a-mdmserver
      # See: https://developer.apple.com/documentation/appleschoolmanagerapi/get-all-device-ids-for-a-mdmserver
      def devices_assigned_to_mdm_server(mdm_server_id, options = {})
        get("v1/mdmServers/#{mdm_server_id}/relationships/devices", options)
      end
    end
  end
end
