module Testrail
  class Project < Testrail::Base
    validates :id, :name, presence: true

    def suites
      @suites = []
      response = client.get_suites(id)
      return @suites unless response.success
      response.payload['suites'].each do |s|
        @suites << Testrail::Suite.new(s)
      end
      @suites
    end

    def add_suite(*args)
      opts = args.last.instance_of?(Hash) ? args.last.merge(project_id: self.id) : {project_id: self.id}
      suite = Testrail::Suite.new(opts)
      if suite.save
        suites #reloads suites
        suite
      else
        false
      end
    end

    def self.all
      results = []
      response = client.get_projects
      return results unless response.success
      response.payload['projects'].each do |p|
        results << Testrail::Project.new(p)
      end
      results
    end

    def self.find(id)
      response = client.get_project(id)
      Testrail::Project.new(response.payload['project'])
    end
  end
end
