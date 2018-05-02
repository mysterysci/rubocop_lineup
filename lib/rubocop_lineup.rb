require "rubocop_lineup/version"
require "rubocop_lineup/line_number_calculator"
require "rubocop_lineup/diff_liner"

module RubocopLineup
  def self.line_em_up(directory)
    git = Git.open(directory)
    Dir.chdir(directory) do
      uncommitted_changes = DiffLiner.new(git.diff('HEAD', '-U0')).changed_line_numbers
      # committed_changes_on_branch = DiffLiner.new(git.diff('HEAD', '-U0')).changed_line_numbers
    end
  end
end
