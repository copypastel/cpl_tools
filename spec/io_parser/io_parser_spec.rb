libdir = File.expand_path(File.dirname(__FILE__) + '/../../lib')
$:.unshift(libdir) unless $:.include? libdir

require 'cpl_tools'

describe CPL::Tools::IOParser do
  describe  CPL::Tools::IOParser::Base do
  end
  #################################
  # Specs for bmp use klingon.bmp #
  describe  CPL::Tools::IOParser::BMP do

    describe "BMP_Header" do
      before(:all) do
        @parser = CPL::Tools::IOParser::BMP::BMP_Header.new
        file = File.open(File.expand_path(File.dirname(__FILE__),"klingon.bmp"))
        @parser.parse(file)
      end
    
      it "should parse the magic number" do
        @parser.format.should eql(:STANDARD)
      end
    end
  end
end