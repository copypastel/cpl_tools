module CPL::Tools::IOParser::BMP
  class BMP_Header < CPL::Tools::IOParser::Base
    #default_endianess :little_endian
    data :flipfart, 2    , :endianess => :big_endian do |dat|
        case [dat[0],dat[1]]
        when [ 0x42 , 0x4D ]: :STANDARD
        when [ 0x42 , 0x41 ]: :OS2_Bitmap_Array
        when [ 0x43 , 0x49 ]: :CI_OS2_Color_Icon
        when [ 0x43 , 0x50 ]: :CP_OS2_Color_Pointer
        when [ 0x49 , 0x43 ]: :IC_OS2_Icon
        when [ 0x50 , 0x54 ]: :PT_OS2_Pointer
        else raise "The file type (magic number) is not supported by a BMP."
      end
    end
    data :file_size,    :uint
    data :reserved,     :uint
    data :data_offset,  :uint
  end

  #dib header for windows V3
  class BMP_DIB_WV3 < CPL::Tools::IOParser::Base
    WV3_SIZE = 40
    VALID_BIT_DEPTHS = [1,4,8,16,24,32]
    default_endianess :little_endian

    data(:size, :uint) {|size| raise "Not the proper DIB_Header" unless size == WV3_SIZE}
    data :width, :int
    data :height, :int
    data :color_plane_number, 2
    data(:bit_depth, 2) {|depth| raise "Invalid Depth" unless VALID_BIT_DEPTHS.include?(depth)}
    data :compression_method, :uint do |method|
      case method           # from wikipedia
      when 0:	:BI_RGB       # none	    Most common
      when 1:	:BI_RLE8      # RLE       8-bit/pixel	Can be used only with 8-bit/pixel bitmaps
      when 2: :BI_RLE4      # RLE       4-bit/pixel	Can be used only with 4-bit/pixel bitmaps
      when 3:	:BI_BITFIELDS #	Bit field	Can be used only with 16 and 32-bit/pixel bitmaps.
      when 4:	:BI_JPEG	    # JPEG	    The bitmap contains a JPEG image
      when 5:	:BI_PNG       # PNG	      The bitmap contains a PNG image
      else raise "The compression_method not recognized"
      end
    end
    data :img_size, :uint
    data :horizontal_resolution, :uint
    data :veticle_resolution, :uint
    data :color_palette_size, :uint
    data :important_color_count, :uint
  end

  class BMP_Image
    attr_reader :header,:dib
    def initialize(file)
      file = File.open(file)
      @header = BMP_Header.parse(file)
      @dib = BMP_DIB_WV3.parse(file)
      @raw = file.read
    end
  end
end