require "rubocop_lineup/version"
require "rubocop_lineup/line_number_calculator"
require "rubocop_lineup/diff_liner"
require "rubocop_lineup/monkey_patch_rubocop"

module RubocopLineup
  # This defaults the parent branch to 'master'. This is a reasonable
  # default, but not always accurate. Unfortunately, due to the nature
  # of git, there is no 100% deterministic way to know the name of the
  # parent branch. There are ways to calculate the parent branch name
  # that cover common cases, but that's more complicated and may be added
  # in a future version.
  def self.line_em_up(directory, parent_branch="master")
    git = Git.open(directory)
    Dir.chdir(directory) do
      uncommitted_changes = DiffLiner.diff_uncommitted.changed_line_numbers
      committed_changes_on_branch = DiffLiner.diff_branch(parent_branch).changed_line_numbers

      # So, what happens when a file has committed changes AND uncommitted_changes?
      # A simple merge like this will overwrite the same filename.
      #
      # Since the uncommitted changes could have substantially altered the state
      # of the file, the line numbers gathered from the committed files diff are
      # not reliable anymore, so only the line numbers from the uncommitted changes
      # will be analyzed. This could lead to unexpected behavior after the file
      # is committed, and then line numbers from previous commits are re-analyzed.
      #
      # TODO: write up a test for all this mess ^^
      committed_changes_on_branch.merge(uncommitted_changes)
    end
  end
end
