CPL_Tools
=========

CPL_Tools is a way for CPL to organize all of its various helpers that we use during development.  CPL\_Tools has all sorts of different applications: from bitmap file conversion for hardware projects, to password management for everyday use.

Projects
--------

There are several different types of projects.  The goal is to create as many standalone projects as possible, but since the tools are smaller we don't want to create an individual repo for each one.  Some of the projects are dependent on one another and the goal is to massage these into a second class of tools which are primarily glue to get the functionality of two stand alone projects working together.

Here is a brief description of the different areas.

### Alchemy ###

Alchemy is simple file type conversion, but in more complex types of files.  Right now Alchemy supports

* BMP    (Windows Image Format)
* CArray (C array's)
* YCbCr  (Video digital compression 4:2:2)

### IO_Parser ###

IO_Parser takes an IO object (anything that has read, and pos=) and parses it into data structures for easy access.  You can think of it like a struct in C where the struct is defined and then overlaid on a character buffere.  An example of a BMP_header follows:

    class BMP_Header < CPL::Tools::IOParser::Base
      #default_endianess :little_endian
      data :format, :string , :endianess => :big_endian, :size => 2 do |dat|
          case [dat[0],dat[1]]
          when [ 0x42 , 0x4D ]: :STANDARD
          when [ 0x42 , 0x41 ]: :OS2_Bitmap_Array
          when [ 0x43 , 0x49 ]: :CI_OS2_Color_Icon
          when [ 0x43 , 0x50 ]: :CP_OS2_Color_Pointer
          when [ 0x49 , 0x43 ]: :IC_OS2_Icon
          when [ 0x50 , 0x54 ]: :PT_OS2_Pointer
          else raise "The file type (magic number) is not supported by a BMP."
        end
      end
      data :file_size,    :uint
      data :reserved,     :uint
      data :data_offset,  :uint
    end

As you read the code you will see something that looks almost like a struct definition where based on the size of the type field (2nd paramater) the data is able to fit properly into the structure without any file parsing.  To use this this code:
    
    header = BMP_Header.new.parse(File.open("file.bmp"))

Immediately you will have access to `header.format` (as a symbol),`header.file_size` (as a uint), and so on.
