module RubocopLineup
  class LineNumberCalculator
    # presumes the text has been parsed already to just the -/+ bits
    # e.g. "-1 +1"
    def self.git_line_summary_to_numbers(text)
      _changed, added = text.split(/ /).reject { |i| i.empty? }
      start, count = added.sub(/^-/, '').split(/,/).map(&:to_i)
      count ||= 1
      (start..(start+count-1)).to_a
    end
  end
end