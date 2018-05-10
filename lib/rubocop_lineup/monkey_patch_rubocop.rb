require 'rubocop'

module DuckPunch
  module CommentConfig
    def cop_enabled_at_line?(cop, line_number)
      source_file = processed_source.path.sub("#{Dir.pwd}/", '')
      files_hash = RubocopLineup.line_em_up(Dir.pwd)
      return false unless files_hash.key?(source_file)
      changed_line_numbers = files_hash[source_file]
      changed_line_numbers.include?(line_number) ? super : false
    end
  end
end

RuboCop::CommentConfig.prepend(DuckPunch::CommentConfig)