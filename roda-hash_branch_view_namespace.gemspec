# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "roda-hash_branch_view_namespace"
  spec.version = "0.1.0"
  spec.authors = ["Henrique F. Teixeira"]
  spec.email = ["hriqueft@gmail.com"]

  spec.summary = "A Roda plugin for match views folders with hash branch namespaces + paths"
  spec.homepage = "https://github.com/roda-project/roda-hash_branch_view_namespace"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/roda-project/roda-hash_branch_view_namespace"
  spec.metadata["changelog_uri"] = "https://github.com/roda-project/roda-hash_branch_view_namespace/blob/main/CHANGELOG.md"

  spec.require_paths = ["lib"]
  spec.files = Dir.glob("{lib}/**/*")
  spec.add_dependency "roda", "~> 3.0"

  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "tilt"
end


