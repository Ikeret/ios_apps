require_relative "./g/google/apis/docs_v1/classes.rb"
require_relative "./g/google/apis/docs_v1/representations.rb"
require_relative "./g/google/apis/docs_v1/service.rb"
require_relative "./g/google/apis/drive_v3/classes.rb"
require_relative "./g/google/apis/drive_v3/representations.rb"
require_relative "./g/google/apis/drive_v3/service.rb"
require_relative "./g/googleauth"
require_relative "./g/googleauth/stores/file_token_store.rb"
# require_relative "./g/fileutils"



OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
APPLICATION_NAME = "Google Docs API Ruby Quickstart".freeze
CREDENTIALS_PATH = "./fastlane/Data/credentials.json".freeze
TOKEN_PATH = "./fastlane/Data/token.yaml".freeze
SCOPE = 'https://www.googleapis.com/auth/documents'

OOB_URI_DRIVE = "urn:ietf:wg:oauth:2.0:oob".freeze
APPLICATION_NAME_DRIVE = "Drive API Ruby Quickstart".freeze
CREDENTIALS_PATH_DRIVE = "./fastlane/Data/credentials_drive.json".freeze
TOKEN_PATH_DRIVE = "./fastlane/Data/token_drive.yaml".freeze
SCOPE_DRIVE = 'https://www.googleapis.com/auth/drive'

def authorize_drive
  client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH_DRIVE
  token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH_DRIVE
  authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE_DRIVE, token_store
  user_id = "default"
  credentials = authorizer.get_credentials user_id
  if credentials.nil?
    url = authorizer.get_authorization_url base_url: OOB_URI_DRIVE
    puts "Open the following URL in the browser and enter the " \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI_DRIVE
    )
  end
  credentials
end

def authorize
  client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
  token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
  authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
  user_id = "default"
  credentials = authorizer.get_credentials user_id
  if credentials.nil?
    url = authorizer.get_authorization_url base_url: OOB_URI
    puts "Open the following URL in the browser and enter the " \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end


module Fastlane
  module Actions
    module SharedValues
      POLYDEV_GOOGLE_DOCS_CUSTOM_VALUE = :POLYDEV_GOOGLE_DOCS_CUSTOM_VALUE
    end

    class PolydevGoogleDocsAction < Action
      def self.run(params)

        service = Google::Apis::DocsV1::DocsService.new
        service.client_options.application_name = APPLICATION_NAME
        service.authorization = authorize

        drive_service = Google::Apis::DriveV3::DriveService.new
        drive_service.client_options.application_name = APPLICATION_NAME_DRIVE
        drive_service.authorization = authorize_drive

        ref_privacy__doc = service.get_document "15Lssx5ZSxLQDG5qTzKN6GBcOxXiws3sW3EiHirmSZMQ"
        ref_support_doc = service.get_document "11fKJSds1BsDnDEN2fEq-dbHyxMUWtF24K6LdOabffJM"
        doc_privacy_id = ""
        doc_support_id = ""

        user_permission = {
            type: 'anyone',
            role: 'reader'
        }

        copy_file = drive_service.copy_file(ref_privacy__doc.document_id)
        doc_privacy_id = copy_file.id
        drive_service.create_permission(copy_file.id, user_permission, fields: 'id')
        copy_file = drive_service.copy_file(ref_support_doc.document_id)
        doc_support_id = copy_file.id
        drive_service.create_permission(copy_file.id, user_permission, fields: 'id')

        return [
          "https://docs.google.com/document/d/#{doc_privacy_id}/edit?usp=sharing",
          "https://docs.google.com/document/d/#{doc_support_id}/edit?usp=sharing"
        ]

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: "FL_POLYDEV_GOOGLE_DOCS_API_TOKEN", # The name of the environment variable
                                       description: "API Token for PolydevGoogleDocsAction", # a short description of this parameter
                                       verify_block: proc do |value|
                                          UI.user_error!("No API token for PolydevGoogleDocsAction given, pass using `api_token: 'token'`") unless (value and not value.empty?)
                                          # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :development,
                                       env_name: "FL_POLYDEV_GOOGLE_DOCS_DEVELOPMENT",
                                       description: "Create a development certificate instead of a distribution one",
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: false) # the default value if the user didn't provide one
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['POLYDEV_GOOGLE_DOCS_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #

        platform == :ios
      end
    end
  end
end
