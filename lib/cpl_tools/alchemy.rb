libdir = File.expand_path(File.dirname(__FILE__))
$:.unshift(libdir) unless $:.include? libdir

require 'alchemy/base.rb'
require 'alchemy/BMP.rb'
require 'alchemy/CArray.rb'
require 'alchemy/YCbCr.rb'
require 'alchemy/File.rb'
