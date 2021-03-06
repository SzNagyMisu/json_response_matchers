# JsonResponseMatchers

[rspec](https://relishapp.com/rspec) matchers for testing json responses in a [rails](https://rubyonrails.org/) application.

## Dependencies

* **ruby** `'>= 2.0.0'`
* **rspec** `'>= 3.0'` <!-- see composable matchers -->
* **activesupport** `'>= 4.0.6'` <!-- see https://github.com/rails/rails/pull/10887 -->

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'json_response_matchers'
end
```

And then execute:

    $ bundle

## Usage

1. include the matchers in your rspec config

  ```ruby
  # spec/rails_helper.rb
  RSpec.configure do |config|
    # you can include it in a general way
    config.include JsonResponseMatchers
    # but it is recommended to include it only for the request
    config.include JsonResponseMatchers, type: :request
    # or the request and controller specs
    config.include JsonResponseMatchers, type: /request|controller/
  end
  ```

2. write more concise request specs

  ```ruby
  # in your request spec examples
  # instead of
  item = JSON.parse(response.body)['item']
  expect(item['name']).to eq 'item-name'
  # use the #have_json_content matcher
  expect(response).to have_json_content('item-name').at_key :item, :name

  # instead of
  items = JSON.parse(repsonse.body)['items']
  expect(items.map { |item| item['id'] }).to match_array [ 1, 2, 3, 4, 5 ]
  # use the #have_json_values matcher
  expect(response).to have_json_values(1, 2, 3, 4, 5).for(:id).at_key :items
  ```

### general rules

The target of the matchers can be a json parsable string or an object with such a string at the method `#body` (like the test response in rails request tests).

```ruby
expect('{"item":{"id":1,"name":"item-name"}}').to have_json_content('item-name').at_key :item, :name
# or if `response.body` contains the above json
expect(response).to have_json_content('item-name').at_key :item, :name
```

The `#at_key` method is optional and can receive one or more `string`, `symbol` or `integer` keys.

```ruby
expect('false').to have_json_content(false)

json = '{"items":[{"id":1,"name":"item-1"},{"id":2,"name":"item-2"}]}'
expect(json).to have_json_values(1, 2).for(:id).at_key 'items'
expect(json).to have_json_values(1, 2).for(:id).at_key :items
expect(json).to have_json_content('item-2').at_key :items, 1, 'name'
```

Both matchers are [composable](https://relishapp.com/rspec/rspec-expectations/docs/composing-matchers).

```ruby
expect('{"item":{"id":1},"user":{"name":"user"}}')
  .to have_json_content(1).at_key(:item, :id)
  .and have_json_values('user').at_key(:user, :name)

expect('{"items":[{"id":1},{"id":2}],"page":1}')
  .to have_json_values(1, 2).for(:id).at_key(:item)
  .and have_json_content(1).at_key(:page)
```

### #have_json_content

Checks single values.

* If expected value is not a `hash`, it checks equality

  ```ruby
  # all pass
  expect('{"string":"string"}').to have_json_content('string').at_key :string
  expect('{"number":123}').to have_json_content(123).at_key :number
  expect('{"boolean":false}').to have_json_content(false).at_key :boolean
  expect('{"array":["a",2]}').to have_json_content([ 'a', 2 ]).at_key :array
  expect('{"null":null}').to have_json_content(nil).at_key :null
  ```

* If expected value is a `hash`
  * and `#with_full_match` is specified, it checks equality
  * otherwise it checks inclusion
  * accepts symbol keys

    ```ruby
    expect('{"id":1,"name":"i1"}').to have_json_content('id'=>1).with_full_match # fails
    expect('{"id":1,"name":"i1"}').to have_json_content('id'=>1) # passes
    expect('{"id":1,"name":"i1"}').to have_json_content(name: 'i1', id: 1).with_full_match # passes
    ```


### #have_json_values

Checks arrays. The expected values are passed as a parameter list (`*args`) to the matcher.

* the metod `#for` is required and can take a `string` or `symbol` value

  ```ruby
  items = [
    { id: 1, name: 'item-1' },
    { id: 2, name: 'item-2' },
    { id: 3, name: 'item-3' }
  ]
  expect(items.to_json).to have_json_values(1, 2, 3).for('id') # passes
  expect(items.to_json).to have_json_values(1, 2, 3).for(:id) # passes
  expect(items.to_json).to have_json_values(*items) # fails with ArgumentError
  ```

* checks order only if `#in_strict_order` is specified

  ```ruby
  expect(items.to_json).to have_json_values(1, 3, 2).for(:id) # passes
  expect(items.to_json).to have_json_values(1, 3, 2).for(:id).in_strict_order # fails
  ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SzNagyMisu/json_response_matchers.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
