# frozen_string_literal: true

RSpec.describe RubocopLineup do
  it "has a version number" do
    expect(RubocopLineup::VERSION).not_to be nil
  end

  let(:gf) { GitFixture.new }

  context "changes same file in prior commit and current working dir" do
    it "only shows uncommitted lines on a file with prior branch changes" do
      gf.make_temp_repo do |dir|
        setup_file_edits("a.txt" => [%w(a b c d e f g h)])
        gf.checkout_branch("my_branch")
        setup_file_edits("a.txt" => [%w(a b c c1 c2 e f g1 g2 h),
                                     %w(a b b1 b2 b3 c c1 e f g2 h)])

        # at this point, the changes adding c1, c2 and g1, g2 are
        # committed, the subsequent changes adding b1-b3 are
        # uncommitted.
        #
        # the diff since the start of the branch reports lines:
        #   [4, 5, 8, 9]
        # but in the uncommitted diff, all of those lines are
        # inaccurate (the contents of line 4 ('c1') are now line 7)
        #
        # the simple way through this mess is to simply favor
        # uncommitted changes over committed changes, knowing the
        # user could have rubocop skip over lines needing to be
        # reported until after they commit and then re-running
        # Rubocop.
        expected = {"a.txt" => [3, 4, 5]}
        expect(RubocopLineup.line_em_up(dir)).to eq expected

        gf.commit_all
        expected = {"a.txt" => [3, 4, 5, 7, 10]}
        RubocopLineup.reset
        expect(RubocopLineup.line_em_up(dir)).to eq expected
      end
    end
  end
end
