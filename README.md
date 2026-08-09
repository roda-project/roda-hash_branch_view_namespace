# Roda::HashBranchViewNamespace

`roda-hash_branch_view_namespace` is a [Roda](https://roda.jeremyevans.net/) plugin that automatically appends subdirectories to your view template search path (`append_view_subdir`) matching your hash branch names and namespaces when routing requests.

It builds upon Roda's built-in `hash_branches` and `view_options` plugins to streamline organizing template views according to your hash branch namespace hierarchy.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "roda-hash_branch_view_namespace"
```

And then execute:

```bash
bundle install
```

Or install it directly:

```bash
gem install roda-hash_branch_view_namespace
```

## Usage

Enable the plugin in your Roda application:

```ruby
class App < Roda
  plugin :render, views: "views"
  plugin :hash_branch_view_namespace

  route do |r|
    r.hash_branches

    r.on "admin" do
      r.hash_branches :admin
    end
  end
end
```

### Automatic View Subdirectory Appending

When you define a hash branch with `hash_branch`, the plugin automatically calls `append_view_subdir("#{namespace}/#{segment}")` before executing the branch block.

#### Default Namespace

```ruby
# Views will automatically look into views/users/
hash_branch("users") do |r|
  # Calls append_view_subdir("users")
  view("index") # renders views/users/index.erb
end
```

#### Custom Namespace

```ruby
# Views will automatically look into views/admin/users/
hash_branch(:admin, "users") do |r|
  # Calls append_view_subdir("admin/users")
  view("index") # renders views/admin/users/index.erb
end
```

## How It Works

1. Loads the `hash_branches` and `view_options` plugins automatically.
2. Wraps route definitions created via `hash_branch(namespace, segment)` to automatically execute `append_view_subdir` prior to yielding control to your route block.
3. Fully supports route redefinition, route removal, subclassing/inheritance, and app freezing (`App.freeze`).

## Development

After checking out the repository, run:

```bash
bin/setup
```

To run the test suite:

```bash
bundle exec rake spec
```

For an interactive prompt to experiment:

```bash
bin/console
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/roda-project/roda-hash_branch_view_namespace.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
