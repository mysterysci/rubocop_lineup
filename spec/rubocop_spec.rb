# frozen_string_literal: true

RSpec.describe RuboCop do
  let(:gf) { GitFixture.new }

  it "works with ranges" do
    gf.make_temp_repo do |dir|
      code = <<~_
        def my_method
          # comment  
        end
      _
      setup_file_edits("foo.rb" => [code])
      gf.checkout_branch("my_branch")
      abc_code = <<~_
        def my_method
          a, b, c, d = (1..4).to_a
          a, b, c, d = (1..4).to_a
          a, b, c, d = (1..4).to_a
        end
      _
      setup_file_edits("foo.rb" => [abc_code])
      result = RuboCop::CLI.new.run(%w(-r rubocop_lineup -o /dev/null --only AbcSize))
      expect(result).to eq RuboCop::CLI::STATUS_OFFENSES
    end
  end
end
