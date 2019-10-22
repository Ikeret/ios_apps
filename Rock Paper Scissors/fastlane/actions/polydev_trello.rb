require_relative './t/trello'


ID_REVIEW = "5d9b86fe67b8458ac10e8183" # "На проверке"
ID_FREE = "5d9b86fe67b8458ac10e8181" # "Пустые аккаунты"
ID_BOARD = "5d9b86fe67b8458ac10e8181"
ID_LABEL_FILL = "5d9b86fe67b8458ac10e819c"


module Fastlane
  module Actions
    module SharedValues
      POLYDEV_TRELLO_CUSTOM_VALUE = :POLYDEV_TRELLO_CUSTOM_VALUE
    end

    class PolydevTrelloAction < Action
      def self.run(params)
        # UI.message ENV["FASTLANE_USER"]
        need_email = ENV["FASTLANE_USER"]
        app_name = ENV["APP_NAME"]

        Trello.configure do |config|
          config.developer_public_key = '8caefc29e59251b00e7e0552a356abe6'
          config.member_token = 'db673541c807209a8c9dfbda82b9d9fe49d590ba4b265c2bd4260d78f7b1bbe0'
        end

        label_fill = Trello::Label.find(ID_LABEL_FILL)

        list = Trello::List.find(ID_FREE)

        list.cards.each { |card|
          if card.name == need_email
            new_card = Trello::Card.create({
                              name: card.name,
                              list_id: ID_REVIEW,
                              desc: "#{card.desc}\n\n#{app_name}",
                              pos: "bottom"
                          })
            new_card.add_label(label_fill)
            card.delete
            break
          end
        }
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
                                       env_name: "FL_POLYDEV_TRELLO_API_TOKEN", # The name of the environment variable
                                       description: "API Token for PolydevTrelloAction", # a short description of this parameter
                                       verify_block: proc do |value|
                                          UI.user_error!("No API token for PolydevTrelloAction given, pass using `api_token: 'token'`") unless (value and not value.empty?)
                                          # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :development,
                                       env_name: "FL_POLYDEV_TRELLO_DEVELOPMENT",
                                       description: "Create a development certificate instead of a distribution one",
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: false), # the default value if the user didn't provide one
         FastlaneCore::ConfigItem.new(
           key: :email,
           env_name: "FASTLANE_USER",
           description: "Email apple id",
           type: String,
           optional: false
         )
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['POLYDEV_TRELLO_CUSTOM_VALUE', 'A description of what this value contains']
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
