require 'omnihooks'
require 'mail'

module OmniHooks
  module Strategies
    class SendgridParse
      include OmniHooks::Strategy
      option :name, 'sendgrid-parse'

      event do
        raw_info
      end

      event_type do
        raw_info['subject']
      end

      private

      def raw_info
        return @raw_info if instance_variable_defined?(:@raw_info)

        parts = Rack::Multipart.parse_multipart(env)
    
        @raw_info = Mail.new do
          header parts['headers']
          text_part { parts['text'] }
          html_part { parts['html'] }
        end 
        
        parts['attachments'].to_i.times do |i|
          attachment = parts["attachment#{i+1}"]
          attachment[:tempfile].rewind
          @raw_info.attachments[attachment[:filename]] = { mime_type: attachment[:type],
                                                            content: attachment[:tempfile].read }
        end

        @raw_info
      end
    end
  end
end