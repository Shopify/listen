# TODO: reduce requires everwhere and be more strict about it
require 'listen'

Listen.logger.level = Logger::WARN unless ENV['LISTEN_GEM_DEBUGGING']

def ci?
  ENV['CI']
end

if ci?
  require 'coveralls'
  Coveralls.wear!
end

Dir["#{__dir__}/support/**/*.rb"].each { |f| require f }

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.order = :random
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  # config.fail_fast = !ci?
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
end

module SpecHelpers
  def fake_path(str, options = {})
    instance_double(Pathname, str, { to_s: str }.merge(options))
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
end

Thread.abort_on_exception = true
