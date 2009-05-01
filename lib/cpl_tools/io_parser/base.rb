module CPL::Tools::IOParser; end
class CPL::Tools::IOParser::Base

  def parse(ioObj)
  end
  
  def self.data prop, type, options = {}, &block
    endianess = options[:endianess] || self.default_endianess
    # Eval this in the inheriting class
    self.subclass.class_eval do
      self.properties.push(DataDescription.new(prop,type,endianess,options,block))
      self.prop_map[prop] = (self.properties.size-1)
      puts("#{prop}")
      eval("def #{prop};self.properties[self.prop_map[#{prop}]].val;end")
    end
  end
  
  def self.inherited(subclass)
    subclass.class_eval do
      @@default_endianess = :big_endian
      def self.default_endianess(endianess = nil)
        @@default_endianess = endianess unless endianess.nil?
        @@default_endianess
      end
      
      @@properties = []
      def self.properties
        @@properties
      end
      
      @@prop_map = {}
      def self.prop_map
        @@prop_map
      end
      
      @@subclass = subclass
      def self.subclass
        @@subclass
      end
    end
  end

  class DataDescription < Struct.new(:prop,:type,:endianess,:options,:block)
    def val
      :standard
    end
  end
end