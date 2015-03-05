def start_sweatshop(for_environment:)
  eye_config = "#{__dir__}/../../robot_sweatshop.#{for_environment}.eye"
  output = `eye load #{eye_config}`
  if $?.exitstatus != 0
    notify :failure, output
  else
    notify :success, "Robot Sweatshop loaded with a #{for_environment} configuration"
    notify :info, `eye restart robot_sweatshop`
    puts 'Check \'eye --help\' for more info on managing the processes'
  end
end
