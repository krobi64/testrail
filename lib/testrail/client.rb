module Testrail
  class Client
    attr_accessor :request

    def initialize
      @request = Testrail::Request
    end

    # Test Results - see http://docs.gurock.com/testrail-api/reference-results
    def add_result(test_id, opts = {})
      request.post('add_result', test_id, opts)
    end

    def add_result_for_case(run_id, case_id, opts = {})
      request.post('add_result_for_case', [run_id, case_id], opts)
    end

    # Test - see http://docs.gurock.com/testrail-api/reference-tests
    def get_test(test_id, opts = {})
      request.get('get_test', test_id, opts)
    end

    def get_tests(run_id, opts = {})
      request.get('get_tests', run_id, opts)
    end

    # Test Cases - see http://docs.gurock.com/testrail-api/reference-cases
    def get_case(case_id, opts = {})
      request.get('get_case', case_id, opts)
    end

    def get_cases(suite_id, section_id, opts = {})
      request.get('get_cases', [suite_id, section_id], opts)
    end

    def add_case(section_id, opts = {})
      request.post('add_case', section_id, opts)
    end

    def update_case(case_id, opts = {})
      request.post('update_case', case_id, opts)
    end

    def delete_case(case_id, opts = {})
      request.post('delete_case', case_id, opts)
    end

    # Suites and Sections - see http://docs.gurock.com/testrail-api/reference-suites
    def get_suite(suite_id, opts = {})
      request.get('get_suite', suite_id, opts)
    end

    def get_suites(project_id, opts = {})
      request.get('get_suites', project_id, opts)
    end

    def get_section(section_id, opts = {})
      request.get('get_section', section_id, opts)
    end

    def get_sections(suite_id, opts = {})
      request.get('get_sections', suite_id, opts)
    end

    def add_suite(project_id, opts = {})
      request.post('add_suite', project_id, opts)
    end

    def add_section(suite_id, opts = {})
      request.post('add_section', suite_id, opts)
    end

    # Test Runs - see http://docs.gurock.com/testrail-api/reference-runs
    def get_run(run_id, opts = {})
      request.get('get_run', run_id, opts)
    end

    def get_runs(project_id, plan_id, opts = {})
      request.get('get_runs', [project_id, plan_id], opts)
    end

    def add_run(suite_id, opts = {})
      request.post('add_run', suite_id, opts)
    end

    def close_run(run_id, opts = {})
      request.post('close_run', run_id, opts)
    end

    # Test Plans - see http://docs.gurock.com/testrail-api/reference-plans
    def get_plan(plan_id, opts = {})
      request.get('get_plan', plan_id, opts)
    end

    def get_plans(project_id, opts = {})
      request.get('get_plans', project_id, opts)
    end

    def add_plan(project_id, opts = {})
      request.post('add_plan', project_id, opts)
    end

    def add_plan_entries(plan_id, opts = {})
      request.post('add_plan_entries', plan_id, opts)
    end

    def close_plan(plan_id, opts = {})
      request.post('close_plan', plan_id, opts)
    end

    # Milestones - see http://docs.gurock.com/testrail-api/reference-milestones
    def get_milestone(milestone_id, opts = {})
      request.get('get_milestone', milestone_id, opts)
    end

    def get_milestones(project_id, opts = {})
      request.get('get_milestones', project_id, opts)
    end

    def add_milestone(project_id, opts = {})
      request.post('add_milestone', project_id, opts)
    end

    # Projects - see http://docs.gurock.com/testrail-api/reference-projects
    def get_project(project_id, opts = {})
      request.get('get_project', project_id, opts)
    end

    def get_projects(opts = {})
      request.get('get_projects', opts)
    end


    # COMMANDS.each do |method_name|
    #   define_method method_name
    # end

    COMMANDS = %w[add_result
                  add_result_for_case
                  get_test
                  get_tests
                  get_case
                  get_cases
                  add_case
                  update_case
                  delete_case
                  get_suite
                  get_suites
                  get_section
                  get_sections
                  add_suite
                  add_section
                  get_run
                  get_runs
                  add_run
                  close_run
                  get_plan
                  get_plans
                  add_plan
                  add_plan_entries
                  close_plan
                  get_milestone
                  get_milestones
                  add_milestone
                  get_project
                  get_projects]
  end
end