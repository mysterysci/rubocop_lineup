require "bundler/setup"
require "rubocop_lineup"
require_relative "git_fixture"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def setup_file_edits(hash)
  hash.each_pair do |filename, (initial_lines, _)|
    gf.write_file(filename, initial_lines)
  end
  gf.commit_all
  hash.each_pair do |filename, (_, new_lines)|
    gf.write_file(filename, new_lines) if new_lines
  end
end
