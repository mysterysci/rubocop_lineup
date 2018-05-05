require_relative 'spec_helper'

RSpec.describe RubocopLineup::DiffLiner do
  let(:gf) { GitFixture.new }

  context "calculates lines of uncommitted files" do
    it "single changed line" do
      gf.make_temp_repo do |dir|
        setup_file_edits('a.txt' => ['initial content', 'updated content'])
        dl = RubocopLineup::DiffLiner.diff_uncommitted(dir)
        expect(dl.files).to eq ['a.txt']
        expect(dl.changed_line_numbers['a.txt']).to eq [1]
      end
    end

    it "two changed lines side-by-side" do
      gf.make_temp_repo do |dir|
        setup_file_edits('a.txt' => [%w(a b c), %w(a y z)])
        dl = RubocopLineup::DiffLiner.diff_uncommitted(dir)
        expect(dl.changed_line_numbers['a.txt']).to eq [2, 3]
      end
    end

    it "two changed lines separated" do
      gf.make_temp_repo do |dir|
        setup_file_edits('a.txt' => [%w(a b c d), %w(a * c *)])
        dl = RubocopLineup::DiffLiner.diff_uncommitted(dir)
        expect(dl.changed_line_numbers['a.txt']).to eq [2, 4]
      end
    end

    it "one line deleted" do
      gf.make_temp_repo do |dir|
        setup_file_edits('a.txt' => [%w(a b c), %w(a c)])
        dl = RubocopLineup::DiffLiner.diff_uncommitted(dir)
        expect(dl.changed_line_numbers['a.txt']).to eq []
      end
    end

    it "one line added" do
      gf.make_temp_repo do |dir|
        setup_file_edits('a.txt' => [%w(a b c), %w(a b q c)])
        dl = RubocopLineup::DiffLiner.diff_uncommitted(dir)
        expect(dl.changed_line_numbers['a.txt']).to eq [3]
      end
    end

    it "one add, one delete, 2 separate changes" do
      gf.make_temp_repo do |dir|
        setup_file_edits('a.txt' => [%w(a aa b c d e f g), %w(A AA b d e E f G)])
        dl = RubocopLineup::DiffLiner.diff_uncommitted(dir)
        expect(dl.changed_line_numbers['a.txt']).to eq [1, 2, 6, 8]
      end
    end

    it "multiple files" do
      gf.make_temp_repo do |dir|
        setup_file_edits('a.txt' => [%w(a b c d), %w(a B c D)],
                         'b.txt' => [%w(1 2 3 4), %w(11 22 3 4)])
        dl = RubocopLineup::DiffLiner.diff_uncommitted(dir)
        expect(dl.changed_line_numbers['a.txt']).to eq [2, 4]
        expect(dl.changed_line_numbers['b.txt']).to eq [1, 2]
      end
    end
  end

  context "calculates lines of all changes on branch" do
    it "single changed line" do
      gf.make_temp_repo do |dir|
        setup_file_edits('a.txt' => [%w(a b c)])
        gf.checkout_branch('my_branch')
        setup_file_edits('a.txt' => [%w(a b c d e f)])
        dl = RubocopLineup::DiffLiner.diff_branch('master', dir)
        expect(dl.files).to eq ['a.txt']
        expect(dl.changed_line_numbers['a.txt']).to eq [4, 5, 6]
      end
    end
  end
end