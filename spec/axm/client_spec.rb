# frozen_string_literal: true

require "axm"

RSpec.describe Axm::Client do
  let(:subject) do
    described_class.new(
      token: "a-valid-token",
      org_type: "business"
    )
  end

  describe "when the token is not provided" do
    let(:subject) do
      described_class.new(
        token: nil,
        org_type: "business"
      )
    end

    it { expect { subject }.to raise_error(ArgumentError, "Provide the token argument") }
  end

  describe "when the org_type is an invalid value" do
    let(:subject) do
      described_class.new(
        token: "a-token-value",
        org_type:
      )
    end

    let(:org_type) { "retail" }

    it "raises an error message" do
      expect { subject }.to raise_error(
        ArgumentError,
        "Provide a valid org_type argument ('business' for Apple Business Manager or 'school' for Apple School Manager) or the api_endpoint argument for your environment"
      )
    end
  end

  describe "when the org_type is not provided" do
    let(:subject) do
      described_class.new(
        token: "a-token-value",
        org_type: nil,
        api_endpoint:
      )
    end

    describe "when the api_endpoint is not provided" do
      let(:api_endpoint) { nil }

      it "raises an error message" do
        expect { subject }
          .to raise_error(
            ArgumentError,
            "Provide a valid org_type argument ('business' for Apple Business Manager or 'school' for Apple School Manager) or the api_endpoint argument for your environment"
          )
      end
    end
  end

  describe "when the org_type is a valid value" do
    let(:subject) do
      described_class.new(
        token: "a-token-value",
        org_type:,
        api_endpoint:
      )
    end

    let(:api_endpoint) { nil }

    describe "and the org_type is 'business'" do
      let(:org_type) { "business" }

      it { expect { subject }.not_to raise_error }
    end

    describe "and the org_type is 'school'" do
      let(:org_type) { "school" }

      it { expect { subject }.not_to raise_error }
    end

    describe "and the api_endpoint is provided" do
      let(:org_type) { "business" }
      let(:api_endpoint) { "https://api-business.apple.com/api/v1" }

      it "raises an error message" do
        expect { subject }
          .to raise_error(
            ArgumentError,
            "Provide either a valid org_type or api_endpoint argument for your environment, not both"
          )
      end
    end
  end
end
