#!/usr/bin/env ruby 
##########################################################################
# vagrant_init.rb
# @author Sebastien Varrette <Sebastien.Varrette@uni.lu>
# Time-stamp: <Thu 2015-05-28 14:06 svarrette>
#
# @description 
#
# Copyright (c) 2014 Sebastien Varrette <Sebastien.Varrette@uni.lu>
# .             http://varrette.gforge.uni.lu
##############################################################################

require 'json'
require 'falkorlib'

include FalkorLib::Common

# Load metadata
basedir   = File.directory?('/vagrant') ? '/vagrant' : Dir.pwd
jsonfile  = File.join( basedir, 'metadata.json')

error "Unable to find the metadata.json" unless File.exists?(jsonfile)

metadata   = JSON.parse( IO.read( jsonfile ) )
name = metadata["name"].gsub(/^[^\/-]+[\/-]/,'') 
modulepath=`puppet config print modulepath`.chomp
moduledir=modulepath.split(':').first

metadata["dependencies"].each do |dep|
	lib = dep["name"]
    shortname = lib.gsub(/^.*[\/-]/,'')
    action = File.directory?("#{moduledir}/#{shortname}") ? 'upgrade' : 'install'
	run %{ puppet module #{action} #{lib} } 
end


puts "Module path: #{modulepath}"
puts "Moduledir:   #{moduledir}" 

info "set symlink to the '#{basedir}' module for local developments"
run %{ ln -s #{basedir} #{moduledir}/#{name}  } unless File.exists?("#{moduledir}/#{name}")
