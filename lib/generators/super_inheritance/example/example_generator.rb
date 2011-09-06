require 'rails'

module SuperInheritance
  module Generators
    class ExampleGenerator < ::Rails::Generators::Base
      SOURCE_ROOT = File.expand_path('../../../templates', __FILE__)
      desc "This generator creates models and migration to play with module"
      source_root SOURCE_ROOT

      def copy_models
        say_status "copying", "models", :green
        Dir[File.join(SOURCE_ROOT, 'models', '*')].each do |fname|
          filename = File.basename(fname)
          copy_file fname, File.join('app', 'models', filename)
        end
      end

      def copy_migrations
        say_status "copying", "migrations", :green
        Dir[File.join(SOURCE_ROOT, 'migrate', '*')].each do |fname|
          filename = File.basename(fname)
          copy_file fname, File.join('db', 'migrate', filename)
        end
      end
    end
  end
end