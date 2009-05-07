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
      header_properties = BMP_Helper.bmp_data[:header].collect {|key,vallue| key}
      header_properties.each do |prop|
        it "should parse the ##{prop}" do
          @header.send(prop).should eql(@expected_header[prop])
        end
      end
    end
    
    describe "Working DIB Parser", :shared => true do
      dib_properties = BMP_Helper.bmp_data[:dib].collect {|key,vallue| key}
      dib_properties.each do |prop|
        it "should parse the ##{prop}" do
          @dib.send(prop).should eql(@expected_dib[prop])
        end
      end
    end    
  end
end