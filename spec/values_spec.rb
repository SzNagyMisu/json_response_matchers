RSpec.describe '#have_json_values' do
  let(:items) do
    {
      items: [
        { name: 'item 1', count: 2 },
        { name: 'item 2', count: 11 },
        { name: 'item 3', count: 0 }
      ]
    }
  end
  let(:json)     { items.to_json }
  let(:response) { Struct.new(:body).new items.to_json }

  it 'works with string keys.' do
    expect(json).to have_json_values('item 1', 'item 2', 'item 3').for('name').at_key('items')
  end

  it 'works with symbol keys.' do
    expect(json).to have_json_values('item 1', 'item 2', 'item 3').for(:name).at_key(:items)
  end

  it 'works with integer keys for array.' do
    json_in_array = [ items ].to_json
    expect(json_in_array).to have_json_values(2, 11, 0).for(:count).at_key 0, :items
  end

  it 'works for the response object.' do
    expect(response).to have_json_values('item 1', 'item 2', 'item 3').for(:name).at_key(:items)
  end

  it 'works for the response body (json string).' do
    expect(response.body).to have_json_values('item 1', 'item 2', 'item 3').for(:name).at_key(:items)
  end

  it 'works with no key passed.' do
    expect(items[:items].to_json).to have_json_values('item 1', 'item 2', 'item 3').for(:name)
  end

  it 'works with multiple keys passed.' do
    expect({ container: items }.to_json).to have_json_values('item 1', 'item 2', 'item 3').for(:name).at_key(:container, :items)
  end

  it 'fails if no :for passed' do
    expect {
      expect(json).to have_json_values('item 1', 'item 2', 'item 3').at_key(:items)
    }.to raise_exception ArgumentError, /set one or more attributes/
  end

  it 'works with multiple :fors passed' do
    expect(json).to have_json_values([ 'item 1', 2 ], [ 'item 2', 11 ], [ 'item 3', 0 ]).for(:name, :count).at_key(:items)
  end

  it 'works with falsy values too.' do
    json = { items: [ { value: nil }, { value: false }, { value: true } ] }.to_json
    expect(json).to have_json_values(nil, false, true).for(:value).at_key :items
  end

  it 'does not check array order by default.' do
    expect(json).to have_json_values('item 2', 'item 1', 'item 3').for(:name).at_key(:items)
  end

  it 'checks array order if #in_strict_order is set.' do
    expect {
      expect(json).to have_json_values('item 2', 'item 1', 'item 3').in_strict_order.for(:name).at_key(:items)
    }.to raise_exception RSpec::Expectations::ExpectationNotMetError
    expect(json).to have_json_values('item 1', 'item 2', 'item 3').for(:name).at_key(:items).in_strict_order
  end

  it 'fails if additional elements are passed as expected.' do
    expect {
      expect(json).to have_json_values('item 1', 'item 2', 'item 3', 'item 4').for(:name).at_key(:items)
    }.to raise_exception RSpec::Expectations::ExpectationNotMetError
    expect {
      expect(json).to have_json_values('item 1', 'item 2', 'item 3', 'item 4').for(:name).at_key(:items).in_strict_order
    }.to raise_exception RSpec::Expectations::ExpectationNotMetError
  end

  it 'fails with error message giving information about order check, actual, expected (and diff).' do
    expect {
      expect(json).to have_json_values('item 1').for(:name).at_key(:items)
    }.to raise_exception RSpec::Expectations::ExpectationNotMetError, /expected\n    \["item 1", "item 2", "item 3"\]\nto match\n    \["item 1"\]/
    expect {
      expect(json).to have_json_values('item 1').for(:name).at_key(:items).in_strict_order
    }.to raise_exception RSpec::Expectations::ExpectationNotMetError, /expected\n    \["item 1", "item 2", "item 3"\]\nto equal\n    \["item 1"\]/
  end

  it 'works as compound matcher.' do
    expect(json).to have_json_values('item 1', 'item 2', 'item 3').for(:name).at_key(:items).and include('"items":')
    expect(json).to have_json_values('item 4', 'item 5', 'item 6').for(:name).at_key(:items).or  include('"items":')
    expect('{"items":[{"id":1},{"id":2}],"page":2}')
      .to have_json_values(1, 2).for(:id).at_key(:items)
      .and have_json_content(2).at_key(:page)
  end
end
