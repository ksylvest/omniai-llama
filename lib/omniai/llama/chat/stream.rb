# frozen_string_literal: true

module OmniAI
  module Llama
    class Chat
      # A stream is used to process a series of chunks of data. It converts the following into a combined payload.
      class Stream < OmniAI::Chat::Stream
        # @yield [delta]
        # @yieldparam delta [OmniAI::Chat::Delta]
        #
        # @return [Hash]
        def stream!(&block)
          @message = { "role" => "assistant" }
          @metrics = []

          @chunks.map do |chunk|
            parser.feed(chunk) do |type, data, id|
              process!(type, data, id, &block)
            end
          end

          {
            "completion_message" => @message,
            "metrics" => @metrics,
          }
        end

      protected

        # @yield [delta]
        # @yieldparam delta [OmniAI::Chat::Delta]
        #
        # @param data [Hash]
        def process_data!(data:, &)
          event = data["event"]

          process_metrics(metrics: event["metrics"])
          process_delta(delta: event["delta"], &)
        end

        # @yield [delta]
        # @yieldparam delta [OmniAI::Chat::Delta]
        #
        # @param delta [hash]
        def process_delta(delta:, &block)
          return unless delta

          text = delta["text"]

          if @message["content"].nil?
            @message["content"] = delta
          else
            @message["content"]["text"] += text
          end

          block&.call(OmniAI::Chat::Delta.new(text:)) if text
        end

        # @param metrics [Array<Hash>]
        def process_metrics(metrics:)
          return unless metrics

          @metrics = metrics
        end
      end
    end
  end
end
