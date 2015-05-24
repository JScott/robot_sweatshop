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

exit_statuses = []
%w(input conveyor payload_parser job_dictionary assembler worker).each do |name|
  exit_statuses.push run_test(name)
end
exit 1 unless non_zero(exit_statuses).empty?

puts "Everything passed successfully" # TODO: announce gem
