libdir = File.expand_path(File.dirname(__FILE__))
$:.unshift(libdir) unless $:.include? libdir


require 'io_parser/base'
require 'io_parser/bmp'

