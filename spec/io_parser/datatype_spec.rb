libdir = File.expand_path(File.dirname(__FILE__) + '/../../lib')
$:.unshift(libdir) unless $:.include? libdir

require 'cpl_tools'

describe CPL::Tools::IOParser do
  describe  CPL::Tools::IOParser::Base::DataType do
    describe "helper functions" do
      it "should be able to convert #IntToBinary" do
        num = 8
        CPL::Tools::IOParser::Base::DataType::IntToBinary(num).should eql([1,0,0,0])
        num = 1835
        CPL::Tools::IOParser::Base::DataType::IntToBinary(num).should eql([1,1,1,0,0,1,0,1,0,1,1])
      end
    end
  end
end
