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
end

run_test 'input'
run_test 'conveyor'
run_test 'payload_parser'
