module Taza
  class Fixture

    def initialize
      @fixtures = {}
    end

    def load_all
      Dir.glob(fixtures_pattern) do |file|
        entitized_fixture = {}
        YAML.load_file(file).each do |key, value|
          entitized_fixture[key] = value.convert_hash_keys_to_methods(self)
        end
        @fixtures[File.basename(file,'.yml').to_sym] = entitized_fixture
      end
    end
    
    def fixtures
      @fixtures.keys
    end
    
    def get_fixture_entity(fixture_file_key,entity_key)
      @fixtures[fixture_file_key][entity_key]
    end

    def pluralized_fixture_exists?(singularized_fixture_name)
      has_fixture_file?(singularized_fixture_name.pluralize_to_sym)
    end

    def has_fixture_file?(fixture)
      @fixtures.keys.include?(fixture)
    end

    def fixtures_pattern
      File.join(base_path, 'fixtures','*.yml')
    end

    def base_path
      File.join('.','spec')
    end
  end
  
  module Fixtures
    def Fixtures.included(other_module)
      zoo = Fixture.new
      zoo.load_all
      zoo.fixtures.each do |fixture|
        self.class_eval do
          define_method(fixture) do |entity_key|
            zoo.get_fixture_entity(fixture,entity_key.to_s)
          end
        end
      end
    end
  end

end