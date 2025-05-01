# frozen_string_literal: true

module OmniAI
  module Llama
    class Chat
      # Overrides choice serialize / deserialize for the following payload:
      #
      #   {
      #     content: {
      #       type: "text",
      #       text: "Hello!",
      #     },
      #     role: "assistant",
      #     stop_reason: "stop",
      #     tool_calls: [],
      #   }
      module MessageSerializer
        # @param data [Hash]
        # @param context [OmniAI::Context]
        #
        # @return [OmniAI::Chat::Message]
        def self.deserialize(data, context:)
          role = data["role"]
          content = OmniAI::Chat::Content.deserialize(data["content"], context:)

          OmniAI::Chat::Message.new(content:, role:)
        end
      end
    end
  end
end
