# frozen_string_literal: true

require "rubocop"

module DuckPunch
  module CommentConfig
    def cop_enabled_at_line?(cop, line_number)
      source_file = processed_source.path
      files_hash = RubocopLineup.line_em_up(Dir.pwd)
      return false unless files_hash.key?(source_file)

      offending_lines = (line_number..last_line).to_a
      changed_line_numbers = files_hash[source_file]
      (changed_line_numbers & offending_lines).empty? ? false : super
    end

    def last_line
      # find_location requires a location symbol in many cases, and usually
      # this can be :expression, but each cop pretty much does its own thing
      # so the hope is this method could be a definitive way to ID the end line.
      processed_source.ast.loc.end.line
    end
  end

  module TargetFinder
    def find(args)
      # returns an array of full file paths that are the files to inspect.
      files = super(args)
      files_hash = RubocopLineup.line_em_up(Dir.pwd)
      files & files_hash.keys
    end
  end
end

RuboCop::CommentConfig.prepend(DuckPunch::CommentConfig)
RuboCop::TargetFinder.prepend(DuckPunch::TargetFinder)
