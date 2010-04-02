module CPL::Tools::Alchemy
  class Base; def to_CArray; raise NotImplementedError; end; end
  
  def self.CArray(alchemist_object)
    alchemist_object.to_CArray
  end
  
  module CArray
    class Base < CPL::Tools::Alchemy::Base
      attr_reader :data, :array_name
      def initialize(data,type,options = {})
        case type
        when :alchemy_YCbCr:
          YCbCrToCArrary(data,options)
        else
          raise NotImplementedError
        end
      end
      
      def to_File(options = {})
        options[:preamble] ||= ""
        CPL::Tools::Alcehmy::File::Base.new(self,options,:alchemy_YCbCr)
      end
      
      private
      def YCbCrToCArray(data,options)
        @data = data.join(',')
        @array_name = options[:name] || "default_name"
      end
    end
  end
end
