require 'rails_helper'

RSpec.describe Config::Clippy do
  describe "#content" do
    it "returns the content from GitHub" do
      raw_config = <<~EOS
        cognitive-complexity-threshold = 30
      EOS
      config = build_config(raw_config)

      expect(config.content).to eq()
    end
  end
end
