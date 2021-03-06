require 'stringio'
module CPL::Tools::Alchemy; end

class CPL::Tools::Alchemy::Base
  # * Each alchemy file adds the conversion to this class
  # * i.e. BMP.rb will:
  #     class Alchemy::Base
  #       def to_BMP; raise NotImplementedError; end
  #     end
  # * It will be up to all the other alchemy files to re-define
  # to_BMP and be completly integrated into the alchemy structure.
end