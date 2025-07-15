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
      # @param device_id [String] The unique identifier of the device to be assigned.
      # @param mdm_server_id [String] The unique identifier of the MDM server to which the device will be assigned.
      # @return [Hash, Integer] The response from the POST method, containing details of the assignment and status code.
      def assign(device_id, mdm_server_id)
        request_body = {
          data: {
            type: "orgDeviceActivities",
            attributes: {
              activityType: "ASSIGN_DEVICES"
            },
            relationships: {
              mdmServer: {
                data: {
                  type: "mdmServers",
                  id: mdm_server_id
                }
              },
              devices: {
                data: [
                  {
                    type: "orgDevices",
                    id: device_id
                  }
                ]
              }
            }
          }
        }

        post("v1/orgDeviceActivities", request_body)
      end
    end
  end
end
