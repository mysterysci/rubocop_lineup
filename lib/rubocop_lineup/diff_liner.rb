module RubocopLineup
  # This class depends on git diffs generated the with -U0 option.
  class DiffLiner
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