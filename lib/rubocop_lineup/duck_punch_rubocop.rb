# frozen_string_literal: true

require "rubocop"

module DuckPunch
  module CommentConfig
    def cop_enabled_at_line?(cop, line_number)
      source_file = processed_source.path
      files_hash = RubocopLineup.line_em_up(Dir.pwd)
      return false unless files_hash.key?(source_file)

      changed_line_numbers = files_hash[source_file]
      changed_line_numbers.include?(line_number) ? super : false

      # Removing support for any line of a block where one or more lines were changed.
      # It's too unpredictable. Linter cops should probably never do this, but I'm
      # not sure how to go about that right now.
      #
      # offending_lines = (line_number..(last_line || line_number)).to_a
      # changed_line_numbers = files_hash[source_file]
      # (changed_line_numbers & offending_lines).empty? ? false : super
    end

    def last_line
      # `loc_end` will be nil in cases like Parser::Source::Map::Collection
      # https://www.rubydoc.info/github/whitequark/parser/Parser/Source/Map/Collection
      # which point to the entire file, but presumably won't have any range
      # cops analyzing it (e.g. Gemfile is like this).

      loc_end = processed_source.ast.loc.end
      loc_end ? loc_end.line : nil
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
