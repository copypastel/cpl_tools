libdir = File.expand_path(File.dirname(__FILE__) + '/../../lib')
$:.unshift(libdir) unless $:.include? libdir

libdir = File.expand_path(File.dirname(__FILE__))
$:.unshift(libdir) unless $:.include? libdir

require 'cpl_tools'
require 'io_parser_helper'

describe CPL::Tools::IOParser do

  describe  CPL::Tools::IOParser::Base do
  end
  #################################
  # Specs for bmp use klingon.bmp #
  describe  CPL::Tools::IOParser::BMP do
    
    describe CPL::Tools::IOParser::BMP::BMP_Header do
      before(:all) do
        @header = CPL::Tools::IOParser::BMP::BMP_Header.new
        @header.parse(BMP_Helper.bmp_file)
        @expected_header = BMP_Helper.bmp_data[:header]
      end
      
      it_should_behave_like "Working BMP_Header Parser"
    end
    
    describe CPL::Tools::IOParser::BMP::BMP_DIB_WV3 do
      before(:all) do
        @dib = CPL::Tools::IOParser::BMP::BMP_DIB_WV3.new
        bmp_file = BMP_Helper.bmp_file
        bmp_file.read(0xE) # header size
        @dib.parse(bmp_file)
        @expected_dib = BMP_Helper.bmp_data[:dib]
      end
      
      it_should_behave_like "Working DIB Parser"
    end
    
    describe CPL::Tools::IOParser::BMP::BMP_Image do
      before(:all) do
        @image = CPL::Tools::IOParser::BMP::BMP_Image.new(BMP_Helper.bmp_file_loc)
        @header = @image.header
        @dib = @image.dib
        @expected_header = BMP_Helper.bmp_data[:header]
        @expected_dib = BMP_Helper.bmp_data[:dib]
      end
      
      it_should_behave_like "Working BMP_Header Parser"
      it_should_behave_like "Working DIB Parser"
      it "should contain the raw data for the image" do
        BMP_Helper.bmp_file.read.include?(@image.raw).should be(true)
      end
    end
  end
end