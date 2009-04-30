module CPL::Tools::Alchemy
  class Base; def to_File; raise NotImplementedError; end; end
  
  def self.File(alchemist_object)
    if alchemist_object.class == String
      file = ::File.new alchemist_object
      CPL::Tools::Alchemy::File::Base.new file
    else
      alchemist_object.to_File
    end
  end
  
  module File
    class Base < CPL::Tools::Alchemy::Base
      attr_reader :file
      def initialize(file)
        @file = file
      end
      
      ###################################
      # Means file is a Binary BMP file #
      def to_BMP
        CPL::Tools::Alchemy::BMP::Base.new(file.read,:string)
      end
    end
  end
end
