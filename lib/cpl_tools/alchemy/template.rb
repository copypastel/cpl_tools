=begin
module CPL::Tools::Alchemy
  class Base; def to_TemplateName; raise NotImplementedError; end; end
  
  def self.TemplateName(alchemist_object)
    alchemist_object.to_TemplateName
  end
  
  module TemplateName
    class Base < CPL::Tools::Alchemy::Base
      #TODO: Add all of your various conversions
    end
  end
end
=end
