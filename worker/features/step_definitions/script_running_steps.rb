Given /^a custom logger$/ do
  @logger = Logger.new STDOUT
end

When /^I run a command$/ do
  run_script 'echo 1', @logger
end

Then /^it has access to the job configuration$/ do
  ENV['SWEATSHOP_BUILD_NUMBER'].nil? ? false : true
end

Then /^the output and exit status are logged$/ do
  expect(@logger).to receive(:info)
  #expect_any_instance_of(Logger).to receive(:info).with(/1/)
  #expect(@output).to match(/1/)
  #expect(@logger).to receive(:info)#.with(/exit status/)
  #expect(@logger).to receive(:info)#.with(/sdfsdf/)
end
