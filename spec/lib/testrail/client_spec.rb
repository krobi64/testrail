require 'spec_helper'
require 'uri'

include URI::Escape

describe Testrail::Client do
  subject { Testrail::Client.new }

  describe "initialize" do
    it "assigns Testrail::Request to @request" do
      subject.request.should eq(Testrail::Request)
    end
  end

  shared_examples_for "an api call" do
    before do
      @parsed_ids = ids.empty? ? '' : '/' + [ids].flatten.join('/')
      opts.merge({body: arguments})
      stub_request(expected_method, url_prefix(command.to_s) + @parsed_ids + key).
              with(opts).
              to_return(status: 200, body: JSON.generate({result: true, an_object: 'abc'}, headers: {}))
      args = []
      args << ids unless ids.empty?
      args << opts unless opts.empty?
      @response = subject.send(command, *args.flatten)
    end

    it "returns a Testrail::Response object" do
      @response.should be_instance_of(Testrail::Response)
    end


    context "successful interaction" do
      it "calls WebMock with the appropriate method " do
        WebMock.should have_requested(expected_method, url_prefix(command.to_s) + @parsed_ids + key).with(opts)
      end

      it "should return Testrail::Response with success set to true" do
        @response.success.should be_true
      end

      it "should return Testrail::Response with a nil @error" do
        @response.error.should be_nil
      end

      it "should return Testrail::Response with a valid body hash" do
        @response.payload.should eq({"an_object"  => "abc"})
      end
    end
  end

  describe "#add_result" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :add_result }
        let(:ids) { 'test_id' }
        let(:arguments) { {status_id: 1,
                           comment: 'a comment',
                           version: 2,
                           elapsed: 24,
                           defects: 'a defect',
                           assignedto_id: 1} }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#add_result_for_case" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :add_result_for_case }
        let(:ids) { ['run_id', 'case_id'] }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#get_test" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_test }
        let(:ids) { 'test_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#get_tests" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_tests }
        let(:ids) { 'run_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#get_case" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_case }
        let(:ids) { 'case_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#get_cases" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_cases }
        let(:ids) { ['suite_id', 'section_id'] }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#add_case" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :add_case }
        let(:ids) { 'section_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#update_case" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :update_case }
        let(:ids) { 'case_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#delete_case" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :delete_case }
        let(:ids) { 'case_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#get_suite" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_suite }
        let(:ids) { 'suite_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#get_suites" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_suites }
        let(:ids) { 'project_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#get_section" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_section }
        let(:ids) { 'section_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#get_sections" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_sections }
        let(:ids) { 'suite_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#add_suite" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :add_suite }
        let(:ids) { 'project_id' }
        let(:arguments) { {name: 'Suite Name',
                           description: 'Suite Description'} }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#add_section" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :add_section }
        let(:ids) { 'suite_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#get_run" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_run }
        let(:ids) { 'run_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#get_runs" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_runs }
        let(:ids) { ['project_id', 'plan_id'] }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#add_run" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :add_run }
        let(:ids) { 'suite_id' }
        let(:arguments) { {name: 'Run Name',
                           description: 'Plan Description',
                           milestone_id: 'M4566',
                           assignedto_id: 'A1',
                           include_all: 0,
                           case_ids: 'C32,C45'} }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#close_run" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :close_run }
        let(:ids) { 'run_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#get_plan" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_plan }
        let(:ids) { 'plan_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#get_plans" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_plans }
        let(:ids) { 'project_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#add_plan" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :add_plan }
        let(:ids) { 'project_id' }
        let(:arguments) { {name: 'Plan Name',
                           description: 'Plan description',
                           milestone_id: 'm34',
                           suite_ids: 'S34,S43'} }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#add_plan_entries" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :add_plan_entries }
        let(:ids) { 'plan_id' }
        let(:arguments) { {suite_ids: 'S34,S43'} }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#close_plan" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :close_plan }
        let(:ids) { 'plan_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#get_milestone" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_milestone }
        let(:ids) { 'milestone_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#get_milestones" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_milestones }
        let(:ids) { 'project_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#add_milestone" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :add_milestone }
        let(:ids) { 'project_id' }
        let(:arguments) { {name: 'Milestone Name',
                           description: 'Milestone Description',
                           due_on: Time.now.to_i} }
        let(:opts) { get_options }
        let(:expected_method) { :post }
      end
    end
  end

  describe "#get_project" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_project }
        let(:ids) { 'project_id' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end

  describe "#get_projects" do
    describe "shared behavior" do
      it_should_behave_like "an api call" do
        let(:command) { :get_projects }
        let(:ids) { '' }
        let(:arguments) { [] }
        let(:opts) { get_options }
        let(:expected_method) { :get }
      end
    end
  end
end