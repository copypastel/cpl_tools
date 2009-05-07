module CPL::Tools::Alchemy
  class Base; def to_BMP; raise NotImplementedError; end; end
  
  def self.BMP(alchemist_object)
    alchemist_object.to_BMP
  end
    
  module BMP
    include CPL::Tools::IOParser::BMP
    
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
    end
  end
end