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
      def initialize(data,format)
        case format
        when :string
          string_initialize(StringIO.new(data))
        else
          raise NotImplementedError
        end
      end
      
      def string_initialize(data)
        @bmp = BMP_Image.new(data)
      end
      
      def to_YCbCr(options = {})
        options[:height] ||= @bmp.dib.height
        options[:width]  ||= @bmp.dib.width
        options[:alignment] ||= :none
        CPL::Tools::Alcehmy::YCbCr::Base.new(@bmp,options,:alchemy_bmp)
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