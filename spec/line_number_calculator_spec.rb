require_relative 'spec_helper'

LNC = RubocopLineup::LineNumberCalculator

RSpec.describe LNC do
  it "one line change" do
    expect(LNC.git_line_summary_to_numbers('-1 +1')).to eq [1]
  end

  it "two line change" do
    expect(LNC.git_line_summary_to_numbers('-2,2 +2,2')).to eq [2, 3]
  end

  it "one line deleted" do
    expect(LNC.git_line_summary_to_numbers('-2 +1,0')).to eq []
  end

  it "one line added" do
    expect(LNC.git_line_summary_to_numbers('-2,0 +3')).to eq [3]
  end
end