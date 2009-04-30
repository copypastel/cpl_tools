libdir = File.expand_path(File.dirname(__FILE__))
$:.unshift(libdir) unless $:.include? libdir

module CPL::Tools::Alchemy; end
require 'stringio'
require 'alchemy/BMP.rb'
require 'alchemy/CArray.rb'
require 'alchemy/YCbCr.rb'
require 'alchemy/File.rb'

class CPL::Tools::Alchemy::Base
  # * Each alchemy file adds the conversion to this class
  # * i.e. BMP.rb will:
  #     class Alchemy::Base
  #       def to_BMP; raise NotImplementedError; end
  #     end
  # * It will be up to all the other alchemy files to re-define
  # to_BMP and be completly integrated into the alchemy structure.
end