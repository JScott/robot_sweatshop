require 'terminal-announce'

# Because of needing to isolate processes, I can't run all tests in one call.
# This means that I have multiple sets of results which isn't nice, but the
#   tests are largely for the sake of TDD anyway.

def run_test(component)
  test_path = File.expand_path __dir__
  IO.popen("ruby #{test_path}/#{component}_spec.rb") do |data|
    while line = data.gets
      puts line
    end
  end
  $?.exitstatus
end

def non_zero(array)
  array.select { |number| number != 0 }
end

tests = %w(
  api
  conveyor
  payload_parser
  job_dictionary
  assembler
  worker
  overseer
  logger
  end-to-end
)
exit_statuses = []

tests.each do |name|
  exit_statuses.push run_test(name)
end
if non_zero(exit_statuses).empty?
  Announce.success 'Everything passed'
else
  failed_tests = tests.each_with_index.select do |test, index|
    exit_statuses[index] != 0
  end
  failed_tests.map! { |test| test[0] }
  Announce.failure "Tests failed: #{failed_tests.join ', '}"
  exit 1
end
