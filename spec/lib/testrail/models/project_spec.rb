require 'spec_helper'

describe Testrail::Project do
  subject { Testrail::Project }

  def valid_attributes(i)
    {"id" => i, 
      "name" => "TestProject #{i}",
    }
  end

  describe "shared behaviors" do
    it_should_behave_like 'a Testrail::Base model object' do
      let(:subject) { Testrail::Project }
      let(:attributes) { valid_attributes(13) }
    end
  end

  describe "individual behaviors" do
    describe ".new" do
      context "with valid attributes" do
        it "returns a valid Project object" do
          subject.new(valid_attributes(1)).should be_valid
        end
      end

      context "with invalid attributes" do
        context "with name missing" do
          before do
            @object = subject.new("id" => 5)
          end

          it "returns an invalid object if name is not provided" do
            @object.should_not be_valid
          end

          it "specifies an error in the name field" do
            @object.valid?
            @object.errors.messages[:name].should eq(["can't be blank"])
          end
        end

        context "with id missing" do
          before do
            @object = subject.new("name" => "A project")
          end

          it "returns an invalid object if id is not provided" do
            @object.should_not be_valid
          end

          it "specifies an error in the id field" do
            @object.valid?
            @object.errors.messages[:id].should eq(["can't be blank"])
          end
        end
      end
    end

    describe ".all" do
      context "one or more existing projects" do
        before do
          @projects = []
          @attributes = []
          3.times do |i|
            @attributes << valid_attributes(i)
            @projects << Testrail::Project.new(valid_attributes(i))
          end
          @results = subject.all
          stub_request(:get, "https://example.testrail.com/index.php?/miniapi/get_projects&key=").
                   with(:headers => {'Accept'=>'application/json'}).
                   to_return(:status => 200, :body => "", :headers => {})        end
    
        it "returns an array" do
          @results.should be_instance_of Array
        end

        it "returns an array of the correct number of objects" do
          @results.size.should eq(@projects.size)
        end
      end
    end
  end
end