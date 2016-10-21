require 'spec_helper'

def make_env(path = '/hooks/sendgrid-parse', props = {})
  {
    'REQUEST_METHOD' => 'POST',
    'PATH_INFO' => path,
    "CONTENT_TYPE" => 'application/x-www-form-urlencoded',
    'rack.session' => {},
    'rack.input' => StringIO.new('test=true'),
  }.merge(props)
end

def multipart_fixture(file_name, boundary = "xYzZY")
  data = File.open(File.expand_path("../../../fixtures/#{file_name}.txt", __FILE__)).read
  type = %(multipart/form-data; boundary=#{boundary})
  length = data.bytesize

  { 
    "CONTENT_TYPE" => type,
    "CONTENT_LENGTH" => length.to_s,
    'rack.input' => StringIO.new(data) 
  }
end

RSpec.describe OmniHooks::Strategies::SendgridParse do
  include Mail::Matchers

  let(:app) do
    lambda { |_env| [404, {}, ['Awesome']] }
  end


  describe '#options' do
    subject { OmniHooks::Strategies::SendgridParse.new(nil) }

    it 'should have a name defined' do
      expect(subject.options.name).to eq('sendgrid-parse')
    end
  end

  describe '#args' do
    it 'has expected arguments' do
      expect(OmniHooks::Strategies::SendgridParse.args).to eq([])
    end
  end

  describe '#call' do
    # Mail::Message is being delieverd to the test system, so we can make assertions on the message
    let(:subscriber) { Proc.new { |m| m.deliver!; m } }
    let(:strategy) { OmniHooks::Strategies::SendgridParse.new(app) }

    before(:each) do
      Mail::TestMailer.deliveries.clear

      OmniHooks::Strategies::SendgridParse.configure do |events|
        events.subscribe('ere', subscriber)
      end
    end

    context 'with a matched event' do
      it 'should pass the event to the subscriber' do
        expect(subscriber).to receive(:call).with(an_email)

        strategy.call(make_env('/hooks/sendgrid-parse', multipart_fixture('matching_event')))
      end

      it 'should have received an e-mail' do
        expect(strategy.call(make_env('/hooks/sendgrid-parse', multipart_fixture('matching_event')))).to have_sent_email
      end   

      it 'should have matching properties' do
        expect(strategy.call(make_env('/hooks/sendgrid-parse', multipart_fixture('matching_event')))).to have_sent_email.to('test@webhooks.getdropstream.com').matching_body('')
      end  
      
    end
  
    context 'with a matched event containg an attachment' do
      it 'should have received an e-mail with attachment' do
        expect(strategy.call(make_env('/hooks/sendgrid-parse', multipart_fixture('matching_event_with_attachements')))).to have_sent_email.with_any_attachments
      end
    end

    context 'with an unmatched event' do
      it 'should pass the event to the subscriber' do
        expect(subscriber).not_to receive(:call)

        strategy.call(make_env('/hooks/sendgrid-parse', multipart_fixture('unmatching_event')))
      end
    end
  
  end
end