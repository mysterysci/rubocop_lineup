module RubocopLineup
  # This class depends on git diffs generated the with -U0 option.
  class LineNumberCalculator
    # presumes the text has been parsed already to just the -/+ bits
    # e.g. "-1 +1"
    def self.git_line_summary_to_numbers(text)
      # TODO: Ruby Golf this - a regex with proper grouping could probably be better.
      _changed, added = text.split(/ /).reject { |i| i.empty? }
      start, count = added.sub(/^-/, '').split(/,/).map(&:to_i)
      count ||= 1
      (start..(start+count-1)).to_a
    end
  end
end