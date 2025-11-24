# frozen_string_literal: true

module Axm
  module Secret
    def self.read(filename)
      File.read("secrets/#{filename}").strip
    end

    def self.write(filename, content)
      File.write("secrets/#{filename}", content.strip)
    end
  end
end
