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

      # Assigns a device to an MDM server.
      #
      # @param device_ids [Array<String>] Array of device IDs to be assigned.
      # @param mdm_server_id [String] The unique identifier of the MDM server to which the device will be assigned.
      # @return [Hash, Integer] The response from the POST method, containing details of the assignment and status code.
      def assign(device_id, mdm_server_id)
        assignment_change(device_id, mdm_server_id, "ASSIGN_DEVICES")
      end

      # Unassigns a device from an MDM server.
      #
      # @param device_ids [Array<String>] Array of device IDs to be unassigned.
      # @param mdm_server_id [String] The unique identifier of the MDM server to which the device will be assigned.
      # @return [Hash, Integer] The response from the POST method, containing details of the assignment and status code.
      def unassign(device_id, mdm_server_id)
        assignment_change(device_id, mdm_server_id, "UNASSIGN_DEVICES")
      end

      private

      # Sends a request to change the assignment of a device to an MDM server.
      #
      # @param device_ids [Array<String>] Array of IDs of devices to be assigned or unassigned.
      # @param mdm_server_id [String] The unique identifier of the MDM server.
      # @param activity_type [String] The type of activity being performed ("ASSIGN_DEVICES" or "UNASSIGN_DEVICES").
      # @return [Hash, Integer] The response from the POST request, containing details of the operation and status code.
      def assignment_change(device_ids, mdm_server_id, activity_type)
        devices = device_ids.map do |device_id|
          {
            type: "orgDevices",
            id: device_id
          }
        end

        request_body = {
          data: {
            type: "orgDeviceActivities",
            attributes: {
              activityType: activity_type
            },
            relationships: {
              mdmServer: {
                data: {
                  type: "mdmServers",
                  id: mdm_server_id
                }
              },
              devices: {
                data: devices
              }
            }
          }
        }

        post("v1/orgDeviceActivities", request_body)
      end
    end
  end
end
