require "rails_helper"

RSpec.describe Linter::Clippy do
  it_behaves_like "a linter" do
    let(:lintable_files) { %w(foo.rs) }
    let(:not_lintable_files) { %w(foo.js) }
  end

  describe "#file_review" do
    it "returns a saved and incomplete file review" do
      linter = build_linter
      commit_file = build_commit_file(filename: "src/lib.rs")

      result = linter.file_review(commit_file)

      expect(result).to be_persisted
      expect(result).not_to be_completed
    end

    it "schedules a review job" do
      build = build(:build, commit_sha: "foo", pull_request_number: 123)
      linter = build_lind(build)
      stub_clippy_config([])
      commit_file = build_commit_file(filename: "src/lib.rs")
      allow(LintersJob).to receive(:perform_async)

      linter.file_review(commit_file)

      expect(LintersJob).to have_received(:perform_async).with(
        filename: commit_file.filename,
        commit_sha: build.commit_sha,
        linter_name: "clippy",
        pull_request_number: build.pull_request_number,
        patch: commit_file.patch,
        content: commit_file.content,
        config: "\n",
        linter_version: nil,
      )
    end
  end

  private

  def stub_clippy_config(config = [])
    stubbed_clippy_config = instance_double(
      Config::Clippy,
      content: config,
      serialize: Config::Serializer.yaml(config),
    )
    allow(Config::Clippy).to receive(:new).and_return(stubbed_clippy_config)

    stubbed_clippy_config
  end
end
