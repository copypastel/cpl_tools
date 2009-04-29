libdir = File.expand_path(File.dirname(__FILE__))
$:.unshift(libdir) unless $:.include? libdir

module CPL; module Tools; end; end
require 'cpl_tools/alchemy'