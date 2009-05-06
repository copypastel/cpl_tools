libdir = File.expand_path(File.dirname(__FILE__) + '/../../lib')
$:.unshift(libdir) unless $:.include? libdir

require 'cpl_tools'

module BMP_Helper
  def self.bmp_file_loc
    File.expand_path(File.dirname(__FILE__)+"/klingon.bmp")
  end
  def self.bmp_file
    File.open(self.bmp_file_loc)
  end
  
  def self.bmp_data
    {
      :header => {
        :format      => :STANDARD,
        :file_size   => 0x181E,
        :data_offset => 0x36
      },
      :dib => {
        :size  => 40,                   #28 00 00 00
        :width => 40,                   #28 00 00 00
        :height => -51,                 #CD FF FF FF
        :color_plane_count => 1,        #01 00
        :bit_depth => 24,               #18 00
        :compression_method => :BI_RGB, #00 00 00 00
        :img_size => 0,                 #00 00 00 00
        :horizontal_resolution => 5669, #25 16 00 00
        :verticle_resolution => 5669,   #25 16 00 00
        :color_palette_size => 0,       #00 00 00 00
        :important_color_count => 0     #00 00 00 00
      }
    }
  end
  module SharedSpecs
    describe "Working BMP_Header Parser", :shared => true do
      describe "BMP_Header" do
        it "should parse the #format" do
          @header.format.should eql(@expected_header[:format])
        end

        it "should parse the #file_size" do
          @header.file_size.should eql(@expected_header[:file_size])
        end

        it "should parse the #data_offset" do
          @header.data_offset.should eql(@expected_header[:data_offset])
        end
      end
    end
    
    describe "Working DIB Parser", :shared => true do
      [:size,:width,:height,:color_plane_count,:bit_depth,:compression_method,
       :img_size,:horizontal_resolution,:verticle_resolution,:color_palette_size,
       :important_color_count].each do |sym|
         it "should parse the ##{sym}" do
           @dib.send(sym).should eql(@expected_dib[sym])
         end
       end
    end    
  end
end

describe CPL::Tools::IOParser do

  describe  CPL::Tools::IOParser::Base do
  end
  #################################
  # Specs for bmp use klingon.bmp #
  describe  CPL::Tools::IOParser::BMP do
    before(:all) do
      include BMP_Helper::SharedSpecs
    end
        
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