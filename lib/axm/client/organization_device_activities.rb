module Axm
  class Client
    module OrganizationDeviceActivities
      # Get information for an organization device activity that a device management action, such as assign or unassign, creates.
      #
      # @param options [Hash] Optional query parameters to filter returned attributes.
      #   - fields: (Array) Array of fields to include in the response.
      # @return [<Hash>] A single organization device activity resource.
      #
      # See: https://developer.apple.com/documentation/applebusinessmanagerapi/get-orgdeviceactivity-information
      # See: https://developer.apple.com/documentation/appleschoolmanagerapi/get-orgdeviceactivity-information
      def org_device_activity(activity_id, options = {})
        get("v1/orgDeviceActivities/#{activity_id}", options)
      end
    end
  end
end
