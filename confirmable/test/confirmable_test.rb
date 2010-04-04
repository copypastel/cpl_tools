#!/usr/bin/env ruby -rubygems

$LOAD_PATH.unshift File.expand_path( File.dirname(__FILE__) + '/../lib')
require 'shoulda'
require 'confirmable'

class ConfirmableTest < Test::Unit::TestCase

  context "Confirmable" do

    context "after being included in a class" do
     
     setup do
       class Foo
         include Confirmable
         def hello; "hello" end
       end
       @foo = Foo.new
     end
     
     should "have #confirm defined" do 
       assert Foo.respond_to? :confirm
     end
     
     should "ignore nonexistant method names" do
       assert_nothing_raised { class Foo; confirm :goodbye end }
       assert !defined?(Foo.new.goodbye)
     end
     
     should "be able to require confirmation for specified methods" do
       assert_equal "hello", @foo.hello
       assert_nothing_raised { class Foo; confirm :hello end }
       assert_raise(SecurityError) { @foo.hello }
       assert_equal "hello", @foo.hello {|c| c.confirm!}
     end
      
    end 
  end
end