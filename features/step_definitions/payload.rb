Given /^a (.*?) payload is put in the '(.*?)' queue$/ do | payload_type, queue_name |
  payload = case payload_type
  when 'BitBucket'
  
  when 'GitHub'
  
  else
  
  end
end

Then /^the payload is parsed to the appropriate hash$/ do
end

Then /^the payload is parsed to nil$/ do
end

Then /^the payload is pushed to the '(.*?)' queue$/ do
end

Then /^the payload is not pushed to the '(.*?)' queue$/ do
end
