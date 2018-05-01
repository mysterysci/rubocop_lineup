require 'tmpdir'
require 'git'

class GitFixture
  def make_temp_repo
    Dir.mktmpdir('test_repo') do |dir|
      @dir = dir
      Git.init(dir)
      @git = Git.open(dir)
      Dir.chdir(dir) do
        write_file('a.txt', 'initial content')
        @git.add(all: true)
        @git.commit('Initial commit', all: true)

        yield dir
      end
    end
  end

  def write_file(filename, content)
    File.open(File.join(@dir, filename), 'w') { |f| f.puts content }
  end

  def diff
    @git.diff.to_s
  end
end