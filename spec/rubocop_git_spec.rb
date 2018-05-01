RSpec.describe RubocopGit do
  it "has a version number" do
    expect(RubocopGit::VERSION).not_to be nil
  end

  it "calculates lines of uncommitted files" do
    gf = GitFixture.new
    gf.make_temp_repo do |dir|
      gf.write_file('a.txt', 'updated content')
      puts gf.diff
    end
  end

  it "calculates lines of files changed on branch" do

  end
end
