require 'thor'
require 'thor/group'
require "active_support/all"
class CreateModel < Thor::Group
  include Thor::Actions
  
  argument :name
  
  desc "Generate model, app, fabricator, and spec files for FCG Service Server"
  
  def self.source_root
    File.join(File.dirname(__FILE__), "../", "generators", "models")
  end
  
  def model
    @model ||= name.downcase.singularize
  end
  
  def model_pluralize
    @model_pluralize ||= model.pluralize
  end
  
  def klass
    @klass ||= model.classify
  end
  
  def create_app_file
    template('app.tt', "lib/fcg-service-servers/apps/#{model}_app.rb")
  end
  
  def create_model_file
    template('model.tt', "lib/fcg-service-servers/models/#{model}.rb")
  end
  
  def create_fabricator_file
    template('fabricator.tt', "spec/fabricators/#{model}_fabricator.rb")
  end
  
  def create_spec_file
    template('spec.tt', "spec/#{model}_spec.rb")
  end
end