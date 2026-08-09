# frozen_string_literal: true

RSpec.describe Roda::RodaPlugins::HashBranchViewNamespace do
  def app(opts = {}, &block)
    @app = Class.new(Roda)
    @app.plugin :hash_branch_view_namespace
    @app.route(&block) if block
    @app
  end

  def req(path = "/", env = {})
    Rack::MockRequest.new(app).get(path, env)
  end

  describe "plugin loading" do
    it "loads hash_branches and view_options plugins automatically" do
      a = app
      expect(a.opts[:hash_branches]).not_to be_nil
      expect(a.opts[:hash_branch_view_subdir_methods]).to eq({})
    end
  end

  describe "hash_branch with view subdirectory appending" do
    it "appends view subdir for default namespace" do
      a = app do |r|
        r.hash_branches
      end

      a.hash_branch(+"", "foo") do
        set_view_subdir("custom")
      end

      response = Rack::MockRequest.new(a).get("/foo")
      expect(response.body).to eq("custom")
    end

    it "appends view subdir for explicit custom namespace" do
      a = app do |r|
        r.on("admin") do
          r.hash_branches(:admin)
        end
      end

      a.hash_branch(:admin, "users") do
        append_view_subdir("list")
      end

      response = Rack::MockRequest.new(a).get("/admin/users")
      expect(response.body).to eq("admin/users/list")
    end
  end

  describe "route redefinition and removal" do
    it "redefines hash branch method when block is provided again" do
      a = app do |r|
        r.hash_branches
      end

      a.hash_branch(+"", "test") { "v1" }
      expect(Rack::MockRequest.new(a).get("/test").body).to eq("v1")

      a.hash_branch(+"", "test") { "v2" }
      expect(Rack::MockRequest.new(a).get("/test").body).to eq("v2")
    end

    it "removes hash branch route when called without block" do
      a = app do |r|
        r.hash_branches
      end

      a.hash_branch(+"", "test") { "hello" }
      expect(Rack::MockRequest.new(a).get("/test").body).to eq("hello")

      a.hash_branch(+"", "test")
      expect(a.opts[:hash_branch_view_subdir_methods][""]["test"]).to be_nil
      expect(Rack::MockRequest.new(a).get("/test").status).to eq(404)
    end
  end

  describe "inheritance" do
    it "duplicates hash_branch_view_subdir_methods into subclass" do
      parent = app
      parent.hash_branch("shared") { "parent route" }

      subclass = Class.new(parent)
      subclass.hash_branch("child_only") { "child route" }

      expect(parent.opts[:hash_branch_view_subdir_methods][""]).to have_key("shared")
      expect(parent.opts[:hash_branch_view_subdir_methods][""]).not_to have_key("child_only")

      expect(subclass.opts[:hash_branch_view_subdir_methods][""]).to have_key("shared")
      expect(subclass.opts[:hash_branch_view_subdir_methods][""]).to have_key("child_only")
    end
  end

  describe "freezing" do
    it "freezes options and inner hashes when app is frozen" do
      a = app
      a.hash_branch("foo") { "bar" }
      a.freeze

      expect(a.opts[:hash_branch_view_subdir_methods]).to be_frozen
      expect(a.opts[:hash_branch_view_subdir_methods][""]).to be_frozen
    end
  end
end
