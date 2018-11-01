require 'json'

module Dropbox
  # Thrown when Dropbox::Client encounters an error unrelated to the API.
  class ClientError < StandardError
    attr_reader :message

    def self.invalid_access_token
      self.new("Invalid access token")
    end

    def self.unknown_response_type(str)
      self.new("Unknown response type '#{str}'")
    end

    def initialize(message=nil)
      @message = message
    end

    def to_s
      @message.to_s
    end
  end

  # Thrown when the API returns an error response.
  class ApiError < StandardError
    attr_reader :message

    def initialize(response)
      if response.content_type.mime_type == 'application/json'
        begin
          @message = "#{response.code}: #{JSON.parse(response)['error_summary']}"
        rescue JSON::ParserError # Dropbox API happily sends broken JSON quite regularly *grumble*
          @message = "#{response.code}: (Invalid JSON -_-) #{response}"
        end
      else
        @message = response
      end
    end

    def to_s
      @message.to_s
    end
  end

  class BadPathAlreadySharedError < ApiError; end
  class BadPathContainsSharedFolderError < ApiError; end
  class FromLookupMalformedPathError < ApiError; end
  class FromLookupNotFoundError < ApiError; end
  class MemberErrorNotAMemberError < ApiError; end
  class PathConflictFolderError < ApiError; end
  class PathDisallowedNameError < ApiError; end
  class PathLookupNotFoundError < ApiError; end
  class PathNotFoundError < ApiError; end
  class ToMalformedPathError < ApiError; end
  class TooManyWriteOperationsError < ApiError; end
end
