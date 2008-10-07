require 'rubygems'
require 'activesupport'

module Taza
  class Site
    attr_accessor :browser
  
    def initialize(params={})
      define_site_pages
      @browser = params[:browser] || Browser.create
    end

    def define_site_pages
      Dir.glob(path) do |file|
        require file

        page_name = File.basename(file,'.rb')
        self.class.class_eval <<-EOS
          def #{page_name}
            yield '#{page_name}'.camelcase.constantize.new
          end
        EOS
      end
    end

    def path
      File.join('pages',self.class.to_s.underscore,'*.rb')
    end
  end 
end

