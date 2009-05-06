module CPL::Tools::IOParser; end
class CPL::Tools::IOParser::Base

  def parse(ioObj)
    self.class.data_types.each do |data_type|
      value = data_type.parse(ioObj)
      self.instance_variable_set("@#{data_type.prop}",value)
    end
  end
  
  def self.data prop, type, options = {}, &block
    endianess = options[:endianess] || self.default_endianess
    self.data_types.push(DataType.new(prop,type,endianess,options,block))
    # Add property definition in evaluating class
    self.subclass.class_eval do
      eval("def #{prop};@#{prop};end")
    end
  end
  
  def self.inherited(subclass)
    subclass.class_eval do
      @default_endianess = :big_endian
      def self.default_endianess(endianess = nil)
        @default_endianess = endianess unless endianess.nil?
        @default_endianess
      end
      
      @data_types = []
      def self.data_types
        @data_types
      end
      
      @subclass = subclass
      def self.subclass
        @subclass
      end
    end
  end

  class DataType < Struct.new(:prop,:type,:endianess,:options,:block)    
    def parse(ioObj)
      value = ioObj.read(self.size)
      value.reverse! if self.endianess == :little_endian
      value = convert(value)
      value = block.call(value) unless block.nil?
      value
    end
    
    def size
      temp_size
    end
    
    def convert(value)
      temp_convert(value)
    end
    
    #These functions could be added to a base class for string and fixnum
    def self.HexstringToFixnum(a)
      s = a.size-1; ret = 0
      a.size.times {|i| ret+= (a[i]<<((s-i)*8))}
      puts ret
      ret
    end

    def self.IntToTwosCompliment(i)
    end
    
    def self.IntToBinary(i)
      #base case
      return [1] if(i == 1)
      DataType::IntToBinary(i/2) + [i%2] 
    end
    
    ##############################################################################################################################
    #BROKEN WINDOW BOARD IT UP!                                                                                                  #
    private                                                                                                                      #
    def temp_size                                                                                                                #
      TYPES[self.type][:size].call(self)                                                                                         #
    end                                                                                                                          #
                                                                                                                                 #
    def temp_convert(string)                                                                                                     #
      TYPES[self.type][:convert].call(self,string)                                                                               #
    end                                                                                                                          #
                                                                                                                                 #
    TYPES = {                                                                                                                    # 
      :uint => {                                                                                                                 #
        :size => Proc.new {|data_type| 4},                                                                                       #
        :convert => Proc.new {|data_type,hex_string| 
          puts hex_string[2]
          DataType::HexstringToFixnum(hex_string) }                                   #
      },                                                                                                                         #
      :int => {                                                                                                                  #
        :size => Proc.new {|data_type| 4},                                                                                       #
        :convert => Proc.new { |data_type,hex_string| DataType::IntToTwosCompliment(DataType::HexstringToFixnum(hex_string) ) }  #
      },                                                                                                                         #
      :string => {                                                                                                               #
        :size => Proc.new { |data_type|                                                                                          #
          raise "String size required if using type string." if(data_type.options[:string_size]).nil?                            #
          data_type.options[:string_size]                                                                                        #
        },                                                                                                                       #
        :convert => Proc.new { |data_type, hex_string| hex_string}                                                               #
      }                                                                                                                          #
    }                                                                                                                            #
    ##############################################################################################################################
  end
end
