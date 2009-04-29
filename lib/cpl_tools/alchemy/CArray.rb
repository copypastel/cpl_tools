module CPL::Tools::Alchemy
  class Base; def to_CArray; raise NotImplementedError; end; end
  
  def self.CArray(alchemist_object)
    alchemist_object.to_CArray
  end
  
  module CArray
    class Base < CPL::Tools::Alchemy::Base
      #TODO: Add all of your various conversions
    end
  end
end
