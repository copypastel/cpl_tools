module CPL::Tools::Alchemy
  class Base; def to_YCbCr; raise NotImplementedError; end; end
  
  def self.YCbCr(alchemist_object)
    alchemist_object.to_YCbCr
  end
  
  module YCbCr
    class Base < CPL::Tools::Alchemy::Base
      #TODO: Add all of your various conversions
    end
  end
end
