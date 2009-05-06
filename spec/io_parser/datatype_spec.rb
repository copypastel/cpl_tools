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
      
      it "should be able to convert a positive int" do
        num = "\xF9" # should convert to -7
        CPL::Tools::IOParser::Base::DataType::HexstringToTwosCompliment(num).should eql(-7)
        num = "\x90\x35"# should convert to -28,619
        CPL::Tools::IOParser::Base::DataType::HexstringToTwosCompliment(num).should eql(-28619)
        num = "\xFF\xFF\xFF\xCD" 
        CPL::Tools::IOParser::Base::DataType::HexstringToTwosCompliment(num).should eql(-51)
      end
    end
  end
end
