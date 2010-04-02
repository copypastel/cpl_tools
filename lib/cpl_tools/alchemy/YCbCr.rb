module CPL::Tools::Alchemy
  class Base; def to_YCbCr; raise NotImplementedError; end; end
  
  def self.YCbCr(alchemist_object)
    alchemist_object.to_YCbCr
  end
  
  module YCbCr
    class Base < CPL::Tools::Alchemy::Base
      attr_reader :data
      def initialize(data,type,options = {})
        case type
        when :alchemy_bmp:
          BMPToYCbCr(data,options)
        else
          raise NotImplementedError
        end
      end
      
      def to_CArray(options = {})
        options[:name] ||= "array"
        CPL::Tools::Alcehmy::CArray::Base.new(@data,options,:alchemy_YCbCr)
      end
      
      private
      # Takes a set of options and must contain a pre-parsed bmp in @bmp.
      # Will return a YCbCr object properly formated.
      def BMPToYCbCr(bmp,options) 
=begin        width_index = 0
        #TODO: add this as on option to allow for YCbCr or YCrCb operation
        cv = 1 # Start off as 1 so the first cycle tips it to 0
        yAlg  = Proc.new { |r,g,b| 16.0  + 1.0/256.0 * (   65.738  * r +  129.057  * g +  25.064  * b) }
        crAlg = Proc.new { |r,g,b| 128.0 + 1.0/256.0 * ( - 37.945  * r -   74.494  * g + 112.439  * b) }
        cbAlg = Proc.new { |r,g,b| 128.0 + 1.0/256.0 * (  112.439  * b -   94.154  * g -  18.285  * b) }
        cycle = Proc.new { |alg1,alg2|  cv = (cv+1 %2); (cv == 0) ? alg1 : alg2 }
        rgb = []
        @data = []
        #TODO: add more diversity to handle more types of alignment options
        raise NotImplementedError unless options[:alignment] == :none
        @bmp.raw.each_byte do |b|
          rgb.push(b) # Construct RGB pair
          if(rgb.size == 3) #if 3 colors found
            y = yAlg.call(rgb)
            cb_or_cr = cycle.call(cbAlg.call(rgb),crAlg.call(rgb))
            rgb = [] # Clear array for next round
            
            @data.push(( y.round << 8 ) + cb_or_cr.round )
            width_index += 1
            # If the width of the image has been reached and padding is needed
            if(@bmp.dib.width == width_index)
              (options[:width] - width_index).times { @data.push(0x1080)}
              width_index = 0
            end
          end
        end
        #@bmp.dib.height is negative
        (options[:height] + @bmp.dib.height).times {
          options[:width].times { @data.push(0x1080)}
        }
=end
      end
      
    end
  end
end
