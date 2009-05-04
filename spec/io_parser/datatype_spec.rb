libdir = File.expand_path(File.dirname(__FILE__) + '/../../lib')
$:.unshift(libdir) unless $:.include? libdir

require 'cpl_tools'

describe CPL::Tools::IOParser do
  describe  CPL::Tools::IOParser::Base::Datatype do
    describe "helper functions" do
      it "should be able to convert #IntToBinary" do
        num = 8
        CPL::Tools::IOParser::Base::Datatype::IntToBinary(8).should eql([1,0,0,0])
      end
    end
  end
end
