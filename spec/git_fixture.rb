require 'tmpdir'
require 'git'

class GitFixture
  def make_temp_repo
    Dir.mktmpdir('test_repo') do |dir|
      @dir = dir
      Git.init(dir)
      @git = Git.open(dir)
      Dir.chdir(dir) do
        yield dir
      end
    end
  end

  def write_file(filename, content)
    File.open(File.join(@dir, filename), 'w') { |f| f.puts Array(content).join("\n") }
  end

  def diff
    # hack on the second arg here. The second arg is an optional `obj2`
    # which is passed to the diff command as if you wanted to diff two
    # shas. We're using it to pass this option through (it just happens to work)
    # to get the more precise diff header to do the counts.
    @git.diff('HEAD', '-U0')
  end

  def commit_all(message="test commit")
    @git.add(all: true)
    @git.commit(message, all: true)
  end
end