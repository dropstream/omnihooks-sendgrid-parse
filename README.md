# Omnihooks::SendgridParse

This gem implements a [Sendgrid Parse Webhook](https://sendgrid.com/docs/API_Reference/Webhooks/parse.html) strategy for [OmniHooks](https://github.com/dropstream/omnihooks). 

The strategy will accept the HTTP POST message from Sendgrid, using the email subject as the event type. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omnihooks-sendgrid-parse'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omnihooks-sendgrid-parse

## Usage


````ruby
Rack::Builder.new do
	use OmniHooks::Builder do
	  provider :sendgrid_parse do
	  	configure do |c|
	  	  c.subscribe 'email subject', Proc.new { |event| nil }
	  	end
	  end
	end
end
````

See [Omnihooks Usage](https://github.com/dropstream/omnihooks#usage) for additional usage options for subscribing to events.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dropstream/omnihooks-sendgrid.

