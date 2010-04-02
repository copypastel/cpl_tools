module CPL::Tools::Alchemy
  class Base; def to_File; raise NotImplementedError; end; end
  
  def self.File(alchemist_object)
    if alchemist_object.class == String
      file = ::File.new alchemist_object
      CPL::Tools::Alchemy::File::Base.new(file,:open_file)
    else
      alchemist_object.to_File
    end
  end
  
  module File
    class Base < CPL::Tools::Alchemy::Base    
      attr_reader :file, :preamble, :write_data
      def initialize(data,type,options = {})
        case type
        when :alchemy_CArray:
          CArrayToFile(data,options)
        when :open_file:
          @file = data
        else
          raise NotImplementedError
        end
      end
      
      ###################################
      # Means file is a Binary BMP file #
      def to_BMP
        CPL::Tools::Alchemy::BMP::Base.new(file.read,:string)
      end
      
      def write
        @file.write(@write_data)
      end
      
      private
      def CArrayToFile(carray,options)
        filename = options[:file_name] || "carray.c"
        @file = ::File.open(File.expand_path(File.dirname(__FILE__) + "/#{filename}",'w'))
        @write_data = options[:preamble] + "#{carray.array_name}[] = {carray.data};"
        write
      end
    end
  end
end
