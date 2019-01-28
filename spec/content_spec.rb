RSpec.describe '#have_json_content' do
  let(:item)     { { item: { name: 'item 1', count: 2 } } }
  let(:json)     { item.to_json }
  let(:nested)   { { items: [ item ] }.to_json }
  let(:response) { Struct.new(:body).new json }

  describe 'the expected value' do
    it 'can be a string.' do
      expect({ string: 'string' }.to_json).to have_json_content('string').at_key(:string)
    end

    it 'can be a number.' do
      expect({ number: 123 }.to_json).to have_json_content(123).at_key(:number)
    end

    it 'can be a boolean.' do
      expect({ boolean: false }.to_json).to have_json_content(false).at_key(:boolean)
    end

    it 'can be an array.' do
      expect({ array: [ :a, 2 ] }.to_json).to have_json_content([ 'a', 2 ]).at_key(:array)
    end

    it 'can be nil.' do
      expect({ null: nil }.to_json).to have_json_content(nil).at_key(:null)
    end

    describe 'can be a hash' do
      it 'with string keys.' do
        expect(json).to have_json_content('name' => 'item 1', 'count' => 2).at_key('item')
      end

      it 'with symbol keys.'do
        expect(json).to have_json_content(name: 'item 1', count: 2).at_key(:item)
      end

      it 'with symbol keys in deep nesting.' do
        expect(nested).to have_json_content(items: [ item: { name: 'item 1', count: 2 } ])
      end
    end
  end


  it 'works for the response object.' do
    expect(response).to have_json_content(name: 'item 1', count: 2).at_key(:item)
  end

  it 'works for the response body (json string).' do
    expect(response.body).to have_json_content(name: 'item 1', count: 2).at_key(:item)
  end

  it 'works with no key passed.' do
    expect(item[:item].to_json).to have_json_content(name: 'item 1', count: 2)
  end

  it 'works with multiple keys passed.' do
    expect({ container: item }.to_json).to have_json_content(name: 'item 1', count: 2).at_key(:container, :item)
  end

  it 'works with symbol, string or integer key.' do
    expect({ items: [ { name: 'item 1' } ] }.to_json).to have_json_content('item 1').at_key('items', 0, :name)
  end

  it 'checks inclusion by default.' do
    expect(json).to have_json_content(name: 'item 1').at_key(:item)
    expect(json).to have_json_content(count: 2).at_key(:item)
  end

  it 'checks equality if #with_full_match is set.' do
    expect {
      expect(json).to have_json_content(name: 'item 1').at_key(:item).with_full_match
    }.to raise_exception RSpec::Expectations::ExpectationNotMetError
    expect(json).to have_json_content(count: 2, name: 'item 1').at_key(:item)
  end

  it 'fails if additional key value pairs are passed as expected.' do
    expect {
      expect(json).to have_json_content(name: 'item 1', count: 2, price: 100).at_key(:item)
    }.to raise_exception RSpec::Expectations::ExpectationNotMetError
    expect {
      expect(json).to have_json_content(name: 'item 1', count: 2, price: 100).at_key(:item).with_full_match
    }.to raise_exception RSpec::Expectations::ExpectationNotMetError
  end

  it 'fails with error message giving information about order check, actual, expected (and diff).' do
    expect {
      expect(json).to have_json_content(name: 'item 2').at_key(:item)
    }.to raise_exception RSpec::Expectations::ExpectationNotMetError, /expected\n    \{"name"=>"item 1", "count"=>2\}\nto include\n    \{"name"=>"item 2"\}/
    expect {
      expect(json).to have_json_content(name: 'item 1').at_key(:item).with_full_match
    }.to raise_exception RSpec::Expectations::ExpectationNotMetError, /expected\n    \{"name"=>"item 1", "count"=>2\}\nto equal\n    \{"name"=>"item 1"\}/
  end

  it 'works as compound matcher.' do
    expect(json).to have_json_content(name: 'item 1', count: 2).at_key(:item).and include('"item":')
    expect(json).to have_json_content(name: 'item 2', count: 1).at_key(:item).or  include('"item":')
  end
end
