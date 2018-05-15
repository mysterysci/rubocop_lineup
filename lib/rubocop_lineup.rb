# frozen_string_literal: true

require "rubocop_lineup/version"
require "rubocop_lineup/line_number_calculator"
require "rubocop_lineup/diff_liner"
require "rubocop_lineup/duck_punch_rubocop"

module RubocopLineup
  # This defaults the parent branch to 'master'. This is a reasonable
  # default, but not always accurate. Unfortunately, due to the nature
  # of git, there is no 100% deterministic way to know the name of the
  # parent branch. There are ways to calculate the parent branch name
  # that cover common cases, but that's more complicated and may be added
  # in a future version.
  def self.line_em_up(directory, parent_branch = "master")
    @line_em_up ||= begin
      Dir.chdir(directory) do
        uncommitted = DiffLiner.diff_uncommitted.file_line_changes
        committed_on_branch = DiffLiner.diff_branch(parent_branch).file_line_changes

        # When a file has committed changes AND uncommitted_changes,
        # we will only include the lines from the uncommitted changes
        # because the lines in the previous committed changes may not
        # be accurate anymore. See test suite for a sample case.

        committed_on_branch.merge(uncommitted)
      end
    end
  end

  def self.reset
    @line_em_up = nil
  end
end
