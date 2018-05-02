RSpec.describe RubocopLineup do
  it "has a version number" do
    expect(RubocopLineup::VERSION).not_to be nil
  end

  it "calculates lines of uncommitted files" do
    gf = GitFixture.new
    gf.make_temp_repo do |dir|
      gf.write_file('a.txt', 'updated content')
    end
  end

  it "calculates lines of files changed on branch" do

  end
end
