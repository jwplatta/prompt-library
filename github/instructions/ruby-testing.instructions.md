---
applyTo: **/*.rb
description: Testing patterns and best practices for Ruby with RSpec
---

# Ruby Testing Patterns

## RSpec Structure

### Basic RSpec Structure
```ruby
RSpec.describe MyClass do
  describe '.build' do
    it 'creates instance from hash data' do
      data = { type: 'CASH', account_number: '12345' }
      instance = described_class.build(data)
      
      expect(instance.type).to eq('CASH')
      expect(instance.account_number).to eq('12345')
    end
  end
  
  describe '#method_name' do
    subject { described_class.new(required_params) }
    
    context 'when condition is met' do
      it 'returns expected result' do
        expect(subject.method_name).to eq(expected_value)
      end
    end
  end
end
```

## Shared Examples

### Creating Shared Examples
```ruby
RSpec.shared_examples "a tradeable instrument" do
  it "has a symbol" do
    expect(subject.symbol).to be_present
  end
  
  it "has a price" do
    expect(subject.price).to be_a(Numeric)
  end
end

RSpec.describe Stock do
  it_behaves_like "a tradeable instrument"
end
```

## Custom Matchers

### Defining Custom Matchers
```ruby
RSpec::Matchers.define :be_profitable do
  match do |position|
    position.current_value > position.cost_basis
  end
  
  failure_message do |position|
    "expected #{position} to be profitable"
  end
end
```

## Mock Objects

### Mock Objects and Stubs
```ruby
let(:mock_client) { instance_double(Client) }
let(:mock_response) { instance_double(Response, body: response_data) }

before do
  allow(ClientFactory).to receive(:create_client).and_return(mock_client)
  allow(mock_client).to receive(:get_account).and_return(mock_response)
end
```

For basic testing patterns, see **ruby-core.instructions.md**. For logging in tests, see **ruby-logging.instructions.md**.