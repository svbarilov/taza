require 'spec/spec_helper'
require 'taza/page'

describe "Taza Page Module" do

  class PageWithModule < ::Taza::Page

    page_module :module do
      element(:module_element) { browser }
    end

  end

  it "should execute elements in the context of their page module" do
    page = PageWithModule.new(:module)
    page.browser = :something
    page.module_element.should eql(:something)
  end

  class AnotherPageWithModule < ::Taza::Page

    page_module :other_module do
      element(:another_module_element) { browser }
    end

  end


  it "should not execute elements that belong to a page module but accessed without it" do
    lambda { AnotherPageWithModule.new.another_module_element }.should raise_error(NoMethodError)
  end

  it "should execute elements in the context of their page module when accessed with it" do
    page = AnotherPageWithModule.new(:other_module)
    page.browser = :another_thing
    page.another_module_element.should eql(:another_thing)
  end


  class TestPageWithModules < ::Taza::Page

    page_module :module_one do
      element(:some_module_element) { :something }
    end

    page_module :module_two do
      element(:some_module_element) { :nothing }
    end

  end

  it "should execute elements with the same name but different page modules" do
    module_one = TestPageWithModules.new(:module_one)
    module_two = TestPageWithModules.new(:module_two)
    module_one.some_module_element.should eql(:something)
    module_two.some_module_element.should eql(:nothing)
  end

  class PageWithMultipleModuleElements < ::Taza::Page

    page_module :module do
      element(:module_element) { :something }
      element(:another_module_element) { :nothing }
    end

  end

  it "should execute elements with the same name but different page modules" do
    page_module = PageWithMultipleModuleElements.new(:module)
    page_module.module_element.should eql(:something)
    page_module.another_module_element.should eql(:nothing)
  end


end
