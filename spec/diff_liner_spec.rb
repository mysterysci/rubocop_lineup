require_relative 'spec_helper'

RSpec.describe RubocopLineup::DiffLiner do
  context "calculates lines of uncommitted files" do
    let(:gf) { GitFixture.new }

    def setup_line_edits(filename, initial_lines, new_lines)
      gf.write_file(filename, initial_lines)
      gf.commit_all
      gf.write_file(filename, new_lines)
    end

    it "single changed line" do
      gf.make_temp_repo do |dir|
        setup_line_edits('a.txt', 'initial content', 'updated content')
        # TODO: the diff call will need to be made by a production class.
        # TODO: \ swap in that class here instead of the fixture
        dl = RubocopLineup::DiffLiner.new(gf.diff)
        expect(dl.files).to eq ['a.txt']
        expect(dl.changed_line_numbers['a.txt']).to eq [1]
      end
    end

    it "two changed lines side-by-side" do
      gf.make_temp_repo do |dir|
        setup_line_edits('a.txt', %w(a b c), %w(a y z))
        dl = RubocopLineup::DiffLiner.new(gf.diff)
        expect(dl.changed_line_numbers['a.txt']).to eq [2, 3]
      end
    end

    it "two changed lines separated" do
      gf.make_temp_repo do |dir|
        setup_line_edits('a.txt', %w(a b c d), %w(a * c *))
        dl = RubocopLineup::DiffLiner.new(gf.diff)
        expect(dl.changed_line_numbers['a.txt']).to eq [2, 4]
      end
    end

    it "one line deleted" do
      gf.make_temp_repo do |dir|
        setup_line_edits('a.txt', %w(a b c), %w(a c))
        dl = RubocopLineup::DiffLiner.new(gf.diff)
        expect(dl.changed_line_numbers['a.txt']).to eq []
      end
    end

    it "one line added" do
      gf.make_temp_repo do |dir|
        setup_line_edits('a.txt', %w(a b c), %w(a b q c))
        dl = RubocopLineup::DiffLiner.new(gf.diff)
        expect(dl.changed_line_numbers['a.txt']).to eq [3]
      end
    end

    it "one add, one delete, 2 separate changes" do
      gf.make_temp_repo do |dir|
        setup_line_edits('a.txt', %w(a b c d e f g), %w(A b d e E f G))
        dl = RubocopLineup::DiffLiner.new(gf.diff)
        expect(dl.changed_line_numbers['a.txt']).to eq [1, 5, 7]
      end
    end
  end
end