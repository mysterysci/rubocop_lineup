# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe RuboCop do
  let(:gf) { GitFixture.new }

  before do
    RubocopLineup.reset
  end

  it "works with ranges" do
    gf.make_temp_repo do |dir|
      setup_file_edits("foo.rb" => [initial_code])
      gf.checkout_branch("my_branch")
      setup_file_edits("foo.rb" => [abc_code])
      runner = RubocopRunner.new(dir)
      runner.run("--only AbcSize")
      check_runner(runner, "foo.rb")
    end
  end

  # this case was blowing up in an earlier implementation of last_line
  it "won't blow up for single line cop in special circumstances" do
    gf.make_temp_repo do |dir|
      setup_file_edits("ignore.rb" => [initial_code])
      gf.checkout_branch("my_branch")
      setup_file_edits("Gemfile" => [gemfile])
      runner = RubocopRunner.new(dir)
      runner.run("--only StringLiterals")
      check_runner(runner, "Gemfile")
    end
  end

  it "only checks changed files" do
    gf.make_temp_repo do |dir|
      setup_file_edits("foo.rb" => [initial_code], "bar.rb" => [abc_code])
      gf.checkout_branch("my_branch")
      setup_file_edits("foo.rb" => [abc_code])
      runner = RubocopRunner.new(dir)
      runner.run("--only AbcSize")
      check_runner(runner, "foo.rb")
    end
  end

  it "only checks changed files included in args" do
    gf.make_temp_repo do |dir|
      code = initial_code
      setup_file_edits("foo.rb" => [code], "bar.rb" => [code], "qux.rb" => [abc_code])
      gf.checkout_branch("my_branch")
      setup_file_edits("foo.rb" => [abc_code], "bar.rb" => [abc_code])

      runner = RubocopRunner.new(dir)
      runner.run("--only AbcSize foo.rb")
      check_runner(runner, "foo.rb")
    end
  end

  it "ignores deleted files" do
    gf.make_temp_repo do |dir|
      setup_file_edits("foo.rb" => [initial_code], "bar.rb" => [initial_code])
      gf.checkout_branch("my_branch")
      gf.delete_file("foo.rb")

      runner = RubocopRunner.new(dir)
      runner.run("--only AbcSize")
      check_runner(runner)
    end
  end

  def initial_code
    <<-_.outdent
      def my_method
        a = 'foo'
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

  def gemfile
    <<-_.outdent
      source 'https://rubygems.org'

      ruby '~> 2.4.0'
    _
  end

  def check_runner(runner, *filenames)
    expected_result = if filenames.empty?
                        RuboCop::CLI::STATUS_SUCCESS
                      else
                        RuboCop::CLI::STATUS_OFFENSES
                      end
    expect(runner.result).to eq expected_result
    expect(runner.output_lines).to eq runner.file_lines(*filenames)
  end

  class RubocopRunner
    attr_reader :result

    def initialize(dir)
      @dir = dir
    end

    def run(args)
      args = "-r rubocop_lineup -f files -o #{output} #{args}"
      @result = RuboCop::CLI.new.run(args.split(" "))
    end

    def output
      File.join(@dir, "offense_files.txt")
    end

    def output_lines
      File.readlines(output).map(&:chomp)
    end

    def file_lines(*args)
      args.map { |filename| File.join(@dir, filename) }
    end
  end
end
