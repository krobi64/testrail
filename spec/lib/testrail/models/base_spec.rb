require 'spec_helper'

describe Testrail::Base do
  it_should_behave_like 'a Testrail::Base object' do
    let(:subject) { Testrail::Base }
    let(:attributes) { {id: 42, an_attribute: 'its value'} }
    let(:expected_json) { JSON.generate({ base: {id: 42, an_attribute: 'its value'} }) }
    let(:expected_hash) { {id: 42, an_attribute: 'its value'} }
  end
end
