# AXM

A Ruby wrapper around the Apple Business Manager (ABM) and Apple School Manager (ASM) APIs. Collectively, they are AXM.

This gem is heavily inspired by [Octokit](https://github.com/octokit/octokit.rb) and [Oktakit](https://github.com/Shopify/oktakit). If you're familiar with those libraries, you should feel right at home.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add axm
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install axm
```

## Usage

First, generate API credentials from the Apple Business Manager or Apple School Manager portal and store the credentials in a secure location accessible to your app.

With the credentials handy, you can create an instance of the client:

```ruby
private_key = File.read('path/to/your/private_key.pem')
client_id = 'your_client_id'
key_id = 'your_key_id'

client = Axm::Client.new(private_key:, client_id:, key_id:)
```

You're now ready to make API requests.

```ruby
client.list_org_devices
```

For any endpoints that don't currently exist in the gem, you can use the `get` or `post` method directly to make API requests

```ruby
client.get('/v1/some/endpoint', { limit: 10 })
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

If the credentials are stored in the `secrets/` directory, you can use the `Secret.read` method to load them:

```ruby
private_key = Secret.read('private_key.pem')
client_id = Secret.read('client_id')
key_id = Secret.read('key_id')

client = Axm::Client.new(private_key:, client_id:, key_id:)
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/nick-f/axm>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nick-f/axm/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Axm project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nick-f/axm/blob/main/CODE_OF_CONDUCT.md).
