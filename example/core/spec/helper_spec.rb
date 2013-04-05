Dir[File.dirname(__FILE__) + '/../lib/*'].each do |file|
  require file
end

Rspec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation
end
