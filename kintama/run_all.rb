Dir.glob("#{__dir__}/*_spec.rb").each do |spec_file|
  require_relative spec_file
end