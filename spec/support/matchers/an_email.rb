RSpec::Matchers.define :an_email do 
  match do |object_instance|
    object_instance.kind_of?(Mail::Message)
  end

  failure_message do |object_instance|
    "expected #{object_instance} to be kind of Mail::Message"
  end

  failure_message_when_negated do |object_instance|
    "expected #{object_instance} not to be kind of Mail::Message"
  end

  description do
    "checks to see if the object is a Mail::Message"
  end
end