shared_examples 'a Testrail::BaseModel object' do
  describe "initialize" do
    context "with unknown attributes" do
      before do
        @object = subject.new(attributes.merge({"unknown_attr" => "unknown_value"}))
      end

      it "creates a new value" do
        @object.attributes[:unknown_attr].should eq("unknown_value")
      end

      it "responds to conventional getter method for the attribute" do
        @object.should respond_to(:unknown_attr)
        @object.unknown_attr.should eq("unknown_value")
      end

      it "responds to the conventional setter method for the attribute" do
        @object.should respond_to(:unknown_attr)
        @object.unknown_attr = 'another unknown value'
        @object.unknown_attr.should eq('another unknown value')
      end
    end
  end

  describe "#to_json" do
    before do
      @object = subject.new(attributes)
      @object_json = @object.to_json
    end

    it "generates correct json" do
      @object_json.should eq(expected_json)
    end    
  end

  describe "#to_h"
    before do
      @object = subject.new(attributes)
      @object_hash = @object.to_h
    end

    it "generates a hash of its attributes" do
      @object_hash.should eq(expected_hash)
    end
end