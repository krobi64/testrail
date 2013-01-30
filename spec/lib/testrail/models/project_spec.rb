require 'spec_helper'
require 'json'

describe Testrail::Project do
  subject { Testrail::Project }

  def valid_attributes(i)
    {"id" => i, 
      "name" => "TestProject #{i}",
    }
  end

  def valid_suite_attributes(i)
    {"id" => i, 
      "name" => "TestSuite #{i}",
      "description" => nil
    }
  end

  describe "shared behaviors" do
    it_should_behave_like 'a Testrail::BaseModel object' do
      let(:subject) { Testrail::Project }
      let(:attributes) { valid_attributes(13) }
      let(:expected_json) { JSON.generate( { project: {id: 13, name: 'TestProject 13'} } ) }
      let(:expected_hash) { {id: 13, name: 'TestProject 13'} }
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

    describe ".find(id)" do
      context "happy path" do
        context "when object exists" do
          before do
            @project = Testrail::Project.new(valid_attributes(23))
            mock_successful_project_find(@project)
            @results = subject.find(23)
          end

          it "returns the correct Project" do
            @results.id.should eq(@project.id)
          end
        end
      end
    end

    describe ".all" do
      context "happy path" do
        context "with one or more existing projects" do
          before do
            @projects = []
            3.times do |i|
              @projects << Testrail::Project.new(valid_attributes(i))
            end
            mock_successful_projects_all(@projects)
            @results = subject.all
          end

          it "returns an array" do
            @results.should be_instance_of Array
          end

          it "returns an array of the correct number of objects" do
            @results.size.should eq(@projects.size)
          end

          it "returns an array of Projects" do
            result_klasses = @results.map(&:class).uniq
            result_klasses.each {|k| k.should eq(subject)}
            @results.each {|p| @projects.map(&:id).should include(p.id) }
          end
        end

        context "with no existing projects" do
          before do
            @projects = []
            mock_successful_projects_all(@projects)
            @results = subject.all
          end

          it "returns an empty array" do
            @results.should be_instance_of Array
            @results.should be_empty
          end
        end
      end
    end

    describe "instance methods" do
      before do
        @project = Testrail::Project.new(valid_attributes(42))
      end

      describe "#add_suite(name)" do
        context "happy path" do
          before do
            mock_sucessful_add_suite(@project, {name: 'A new Suite', description: nil})
            mock_successful_suites_all
            @project.add_suite('A new Suite')
          end

          it "creates the suite" do
            @project.suites.first.should be_instance_of(Testrail::Suite)
          end

          it "creates a valid suite" do
            @project.suites.first.should be_valid
          end
        end
      end
    end
    # describe "#suites" do
    #   before do
    #     @result = @project.suites
    #   end
    # 
    #   it "returns an Array" do
    #     @result.should be_instance_of Array
    #   end
    #   
    # end
  end
end