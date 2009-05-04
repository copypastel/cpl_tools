module CPL::Tools::IOParser; end
class CPL::Tools::IOParser::Base

  def parse(ioObj)
    self.class.datatypes.each do |datatype|
      value = datatype.parse(ioObj)
      self.instance_variable_set(datatype.prop,value)
    end
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
    self.datatypes.push(DataType.new(prop,type,endianess,options,block))
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

  class DataType < Struct.new(:prop,:type,:endianess,:options,:block)
    def convert(ioObj)
      value = ioObj.read(self.size)
      value.reverse! if ioObj.endianess == :little_endian
      self.convert(value)
    end
    
    def size
      
    end
    
    def convert(string)
    end
    
    #These functions could be added to a base class for string and fixnum
    def self.HexstringToFixnum(a)
      s = a.size-1
      a.size.times {|i| ret+= (a[i]<<((s-i)*4))}
    end
    
    def self.IntToTwosCompliment(i)
      
    end
    
    def self.IntToBinary(i)
      #base case
      return [i%2] if(i == 2 or i == 1)
      [i%2] + DataType::IntToBinary(i/2)
    end
    
    TYPES = {
      :uint => {
        Block.new {4},
        Block.new { |string| DataType::HexstringToFixnum(string) }
      },
      :int => {
        Block.new {4},
        Block.new { |string| DataType::IntToTwosCompliment(DataType::HexstringToFixnum(string) ) }
      }
    }
  end
end