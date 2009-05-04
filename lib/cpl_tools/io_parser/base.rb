module CPL::Tools::IOParser; end
class CPL::Tools::IOParser::Base
  DATATYPES = {
    :uint => {
      :size => 3,
      :convert => 3
    },
    :int => {
      :size => 3,
      :convert => 3
    },
    :string => {
      :size => 3,
      :convert =>
    }
  }

  def parse(ioObj)
    self.class.datatypes.each do |datatype|
      value = parse_datatype(datatype,ioObj)
      value = datatype.block.call(value) unless datatype.block.nil?
      self.instance_variable_set(datatype.prop,value)
    end
  end
  
  def parse_datatype(datatype,ioObj)
    value = ioObj.read(DATATYPES[datatype.type].size(datatype))
    value.reverse! if(datatype.endianess == :little_endian)
    value = DATATYPES[datatype.type].convert(ioObj)
    value = ioObj.read(type_size(datatype))
    value = case datatype.type
    when :uint:   ioObj.read(4)
    when :int:    ioObj.read(4)
    when :string: ioObj.read(datatype.options[:string_size])
    end
    value.reverse! if(datatype.endianess == :little_endian)
    value = case datatype.type
    when :uint
    when :int
    when :string
    end
    value
  end
  
  def type_size(datatype)
    when :uint:   ioObj.read(4)
    when :int:    ioObj.read(4)
    when :string: datatype.options[:string_size]
    end
  end
  
  def parse_with_symbol(datatype,ioObj)
  end
  
  def self.data prop, type, options = {}, &block
    endianess = options[:endianess] || self.default_endianess
    self.datatypes.push(DataDescription.new(prop,type,endianess,options,block))
    # Add property definition in evaluating class
    self.subclass.class_eval do
      eval("def #{prop};@#{prop};end")
    end
  end
  
  def self.inherited(subclass)
    subclass.class_eval do
      @@default_endianess = :big_endian
      def self.default_endianess(endianess = nil)
        @@default_endianess = endianess unless endianess.nil?
        @@default_endianess
      end
      
      @@datatypes = []
      def self.datatypes
        @@datatypes
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