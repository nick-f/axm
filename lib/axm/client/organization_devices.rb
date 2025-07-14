module Axm
  class Client
    module OrganizationDevices
      # Retrieves a list of devices associated with the organization.
      #
      # @param options [Hash] Optional query parameters to filter or paginate results.
      #   - fields: (Array) Array of fields to include in the response.
      #   - limit: (Integer) Maximum number of devices to return per page (default: 100).
      # @return [Array<Hash>] An array of device objects.
      #
      # See: https://developer.apple.com/documentation/applebusinessmanagerapi/get-org-devices
      # See: https://developer.apple.com/documentation/appleschoolmanagerapi/get-org-devices
      def list_org_devices(options = {})
        get("v1/orgDevices", options)
      end

      # Retrieves information about a specific device in the organization.
      #
      # @param options [Hash] Optional query parameters to filter or paginate results.
      #   - fields: (Array) Array of fields to include in the response.
      # @return [<Hash>] A device and its selected attributes.
      #
      # See: https://developer.apple.com/documentation/applebusinessmanagerapi/get-orgdevice-information
      # See: https://developer.apple.com/documentation/appleschoolmanagerapi/get-orgdevice-information
      def device(id, options = {})
        get("/v1/orgDevices/#{id}", options)
      end
    end
  end
end
