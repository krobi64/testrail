shared_examples 'a Testrail::Base model object' do
  describe "initialization" do
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
end