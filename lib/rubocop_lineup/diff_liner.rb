# frozen_string_literal: true

require "git"

module RubocopLineup
  # This class depends on git diffs generated the with -U0 option.
  class DiffLiner
    def self.diff_uncommitted(dir = Dir.pwd)
      new(diff_from(dir, "HEAD"), dir)
    end

    def self.diff_branch(parent_branch, dir = Dir.pwd)
      new(diff_from(dir, "#{parent_branch}..."), dir)
    end

    def self.diff_from(dir, obj)
      # The -U0 option is essential to how this gem works, since it eliminates
      # any unchanged lines in the output, allowing for simple math based on
      # the line number header in the git output.

      Git.open(dir).diff(obj, "-U0")
    end

    # Expects a Git::Diff instance, which handles parsing diff output into files.
    def initialize(diff, dir)
      @dir = dir
      process(diff)
    end

    def filenames
      @data_full_paths.keys
    end

    def file_line_changes
      @data_full_paths
    end

    private

    def process(diff)
      @data_full_paths = Hash[diff.map { |diff_file| process_diff_file(diff_file) }]
    end

    def process_diff_file(diff_file)
      [File.join(@dir, diff_file.path),
       calc_line_numbers(diff_file.patch.scan(/^@@(.*)@@/).flatten)]
    end

    def calc_line_numbers(diff_line_summaries)
      diff_line_summaries.map do |line_summary|
        LineNumberCalculator.git_line_summary_to_numbers(line_summary.strip)
      end.flatten
    end
  end
end
