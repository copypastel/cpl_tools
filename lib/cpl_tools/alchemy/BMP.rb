module CPL::Tools::Alchemy
  class Base; def to_BMP; raise NotImplementedError; end; end
  
  def self.BMP(alchemist_object)
    alchemist_object.to_BMP
  end
  
  module BMP
    class Base < CPL::Tools::Alchemy::Base
    end
  end
end