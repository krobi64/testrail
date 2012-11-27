require 'active_model'

module Testrail
  class Project < Testrail::BaseModel
    include ActiveModel::Validations
    extend ActiveModel::Naming

    validates :id, presence: true
    validates :name, presence: true

    def self.all
      results = []
      response = client.get_projects
    end

    private

    def self.client
      @_client ||= Testrail::Client.new
    end
  end
end