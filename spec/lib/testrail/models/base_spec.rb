require 'spec_helper'

describe Testrail::BaseModel do
  it_should_behave_like 'a Testrail::BaseModel object' do
    let(:subject) { Testrail::BaseModel }
    let(:attributes) { {id: 42, an_attribute: 'its value'} }
    let(:expected_json) { JSON.generate({ base_model: {id: 42, an_attribute: 'its value'} }) }
    let(:expected_hash) { {id: 42, an_attribute: 'its value'} }
  end
end