require "faraday"
require "hugging_face/inference/tasks/computer_vision"

module HuggingFace
  module Inference
    class Client
      include HuggingFace::Inference::Tasks::ComputerVision
  
      class Configuration
        attr_accessor :url, :access_token
  
        DEFAULT_URL = "https://api-inference.huggingface.co".freeze
  
        def initialize(url = nil, access_token = nil)
          @url = url || DEFAULT_URL
          @access_token = access_token
        end
      end
      
      class << self
        attr_writer :configuration
      end
  
      def self.configuration
        @configuration ||= HuggingFace::Inference::Client::Configuration.new
      end
  
      def self.configure
        yield(configuration)
      end
  
      private
  
        def default_conn
          Faraday.new(
            url: self.class.configuration.url,
            headers: {
              'Authorization' => "Bearer #{self.class.configuration.access_token}",
              'Content-Type' => 'application/json',
              'User-Agent' => "HuggingFaceRuby/0.0.1"
            }
          )
        end
    end
  end
end
