# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe RuboCop do
  let(:gf) { GitFixture.new }

  before do
    RubocopLineup.reset
  end

  it "works with ranges" do
    gf.make_temp_repo do |_dir|
      setup_file_edits("foo.rb" => [initial_code])
      gf.checkout_branch("my_branch")
      setup_file_edits("foo.rb" => [abc_code])
      result = RuboCop::CLI.new.run(%w(-r rubocop_lineup -o /dev/null --only AbcSize))
      expect(result).to eq RuboCop::CLI::STATUS_OFFENSES
    end
  end

  it "only checks changed files" do
    gf.make_temp_repo do |dir|
      code = initial_code
      setup_file_edits("foo.rb" => [code], "bar.rb" => [abc_code])
      gf.checkout_branch("my_branch")
      setup_file_edits("foo.rb" => [abc_code])
      output = File.join(dir, "offense_files.txt")
      args = "-r rubocop_lineup -f files -o #{output} --only AbcSize"
      result = RuboCop::CLI.new.run(args.split(" "))
      puts File.read output
      expect(result).to eq RuboCop::CLI::STATUS_OFFENSES
      expect(File.read(output).chomp).to eq File.join(dir, "foo.rb")
    end
  end

  def initial_code
    <<-_.outdent
      def my_method
        # comment
      end
    _
  end

  def abc_code
    <<-_.outdent
      def my_method
        a, b, c, d = (1..4).to_a
        a, b, c, d = (1..4).to_a
        a, b, c, d = (1..4).to_a
      end
    _
  end
end
