module CPL::Tools::Alchemy
  class Base; def to_BMP; raise NotImplementedError; end; end
  
  def self.BMP(alchemist_object)
    alchemist_object.to_BMP
  end
    
  module BMP
    class InvaladFileFormat < RuntimeError; end
    
    def self.load_file(file)
      CPL::Tools::Alchemy::File(file).to_BMP
    end
    
    class Base < CPL::Tools::Alchemy::Base
      attr_reader :BMP_Header, :DIB_Header, :IMG_Data
      def initialize(data,format)
        case format
        when :string
          string_initialize(StringIO.new(data))
        else
          raise NotImplementedError
        end
      end
      
      def string_initialize(data)
        @BMP_Header = BMP_Header.new( data                                  ) 
        @DIB_Header = DIB_Header.new( data, self.BMP_Header                 )
        @IMG_Data   = IMG_Data.new(   data, self.BMP_Header,self.DIB_Header )
        puts self.BMP_Header.data_offset
      end
            
    private
      class IMG_Data 
        attr_reader :raw,:img_start
        def initialize(data,bmp_header,dib_header)
          data.pos = @img_start = bmp_header.data_offset
          @raw = data.read
        end
      end
      
      class BMP_Header
        HEADRER_START = 0
        HEADER_SIZE   = 0x0E
        #Locations
        MAGIC_NUMBER  = 0x00 ... 0x02
        DATA_OFFSET   = 0x0A ... 0x0E
        #            File Type     Hex value of data start
        attr_reader :raw,:magic_number, :data_offset
        def initialize(data)
          data.pos = HEADER_START
          
          @raw          = BMP::AsciiToDecimal(data.read(HEADER_SIZE))
          @magic_number = GetMagicNumber(self.raw)
          @data_offset  = BMP::ReadData(self.raw,DATA_OFFSET,:little_endian )
        end
        
        def GetMagicNumber(header)
          @magic_number = case header[ MAGIC_NUMBER ]
            when [0x42,0x4D]: :STANDARD
            when [0x42,0x41]: :OS2_Bitmap_Array
            when [0x43,0x49]: :CI_OS2_Color_Icon
            when [0x43,0x50]: :CP_OS2_Color_Pointer
            when [0x49,0x43]: :IC_OS2_Icon
            when [0x50,0x54]: :PT_OS2_Pointer
            else raise InvaladFileFormat("The file type (magic number) is not supported by a BMP.")
          end
        end
        # Simple little algorythm to get decimal value of offset.
        # Will convert it to more generic function if I use it again.
        def ArrayToDataOffset(a)
          t = 0; a.size.times {|i| t+= (a[i]<<((a.size-i-1)*4))}; t
        end
      end
      
      class DIB_Header
        DIB_START      = 0xE
        DIB_SIZE_TYPE  = DWORD
        
        attr_reader :raw, :dib_size
        def initialize(data,bmp_header)
          data.pos = DIB_START
          dib_size_raw = BMP::AsciiToDecimal(data.read(DIB_SIZE_LOC))
          @dib_size    = BMP::ReadData(dib_size_raw,DIB_SIZE,:little_endian)
          
          @raw = BMP::AsciiToDecimal(data.read(@dib_size-DIB_SIZE))
          @raw = bmp_header.raw + BMP::AsciiToDecimal(data.read(@dib_size))
        end
      end
    end
    
    class << self
      # The ascii values are escaped \0## if no representation is available.
      # The escape is for Octal and not Hex.
      def AsciiToDecimal(ascii)
        result = []
        ascii.size.times {|i| result.push(ascii[i])}
        result
      end
      
      def ReadData(data,range,endianess)
        a = data[range]; ret = 0
        case endianess
        #LSB First
        when :little_endian 
          s = a.size-1
          a.size.times {|i| ret+= (a[s-i]<<((s-i)*4))}
        #MSB first
        when :big_endian
          s = a.size-1
          a.size.times {|i| ret+= (a[i]<<((s-i)*4))}
        else 
          raise NotImplementedError
        end
        ret
      end
    end
  end
end