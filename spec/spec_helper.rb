# frozen_string_literal: true

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

module RubocopLineup
  class DiffLiner
    def strip_root!
      @data_full_paths =
        Hash[@data_full_paths.map { |k, v| [k.sub(%r{^#{@dir}/?}, ""), v] }]
      self
    end
  end
end

class String
  # ActiveSupport strip_heredoc
  def outdent
    indent = scan(/^[ \t]*(?=\S)/).min.size || 0
    gsub(/^[ \t]{#{indent}}/, "")
  end
end
