# frozen_string_literal: true

module RubocopLineup
  # This class depends on git diffs generated the with -U0 option.
  class DiffLiner
    def self.diff_uncommitted(dir = Dir.pwd)
      new(diff_from(dir, "HEAD"))
    end

    def self.diff_branch(parent_branch, dir = Dir.pwd)
      new(diff_from(dir, "#{parent_branch}..."))
    end

    def self.diff_from(dir, obj)
      # The -U0 option is essential to how this gem works, since it eliminates
      # any unchanged lines in the output, allowing for simple math based on
      # the line number header in the git output.

      Git.open(dir).diff(obj, "-U0")
    end

    # Expects a Git::Diff instance, which handles parsing diff output into files.
    def initialize(diff)
      @data = process(diff)
    end

    def files
      @data.keys
    end

    def changed_line_numbers
      @data
    end

    private

    def process(diff)
      Hash[diff.map { |diff_file| process_diff_file(diff_file) }]
    end

    def process_diff_file(diff_file)
      [diff_file.path,
       calc_line_numbers(diff_file.patch.scan(/@@(.*)@@/).flatten)]
    end

    def calc_line_numbers(diff_line_summaries)
      diff_line_summaries.map do |line_summary|
        LineNumberCalculator.git_line_summary_to_numbers(line_summary.strip)
      end.flatten
    end
  end
end
