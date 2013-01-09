require 'json'
require 'uri'

include URI::Escape
MockObject = Struct.new(:id, :name)

def setup_body(enum)
  result = []
  enum.each do |k, v|
    result << "#{k}=#{encode(String(v))}"
  end
  result.join('&')
end

def mock_successful_projects_all(projects)
  result_json = {
    result: true
  }
  result_json[:projects] = [].tap do |ary|
    projects.each do |p|
      ary << p.to_h
    end
  end
  stub_request(:get, "https://example.testrail.com/index.php?/miniapi/get_projects&key=").
           with(headers: {'Accept'=>'application/json'}).
           to_return(status: 200, body: JSON.generate(result_json))
end

def mock_successful_project_find(project)
  result_json = {
    result: true,
    project: project.to_h
  }
  stub_request(:get, "https://example.testrail.com/index.php?/miniapi/get_project/#{project.id}&key=").
           with(headers: {'Accept'=>'application/json'}).
           to_return(status: 200, body: JSON.generate(result_json))
end

def mock_successful_suites_all
  @suites = [].tap do |ary|
    2.times do |i|
      ary << MockObject.new(i, "Suite #{i}")
    end
  end
  result_json = {
    result: true
  }
  result_json[:suites] = @suites.map{|s| {id: s.id, name: s.name}}
  stub_request(:get, "https://example.testrail.com/index.php?/miniapi/get_suites/#{@project.id}&key=").
           with(headers: {'Accept'=>'application/json'}).
           to_return(status: 200, body: JSON.generate(result_json))
end

def mock_sucessful_add_suite(project, attributes)
  result_json = {
    result: true,
    id: 2,
    url: 'some_url' 
  }
  body = setup_body(attributes)
  stub_request(:post, "https://example.testrail.com/index.php?/miniapi/add_suite/#{project.id}&key=").
    with(body: body,
         headers: {'Accept'=>'application/json'}).
    to_return(status: 200, body: JSON.generate(result_json), :headers => {})  
end