#------------------------------------------------------------------------------
# Copyright (c) 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

require "bundler/setup"
require "forwardable"
require "json"
require "time"
require "ucf"
require "uri"
require "uuid"

require "ro-bundle/version"
require "ro-bundle/util"
require "ro-bundle/exceptions"
require "ro-bundle/ro/agent"
require "ro-bundle/ro/provenance"
require "ro-bundle/ro/manifest-entry"
require "ro-bundle/ro/proxy"
require "ro-bundle/ro/annotation"
require "ro-bundle/ro/aggregate"
require "ro-bundle/ro/manifest"
require "ro-bundle/ro/directory"
require "ro-bundle/file"

# This is a ruby library to read and write Research Object Bundle files in PK
# Zip format. See the ROBundle::File class for more information.
#
# See
# {the RO Bundle specification}[https://w3id.org/bundle/] for more details.
#
# Most of this library's API is provided by two underlying gems. Please
# consult their documentation in addition to this:
#
# * {zip-container gem}[https://rubygems.org/gems/zip-container]
#   {documentation}[http://mygrid.github.io/ruby-zip-container/]
# * {ucf gem}[https://rubygems.org/gems/ucf]
#   {documentation}[http://mygrid.github.io/ruby-ucf]
#
# There are code examples available with the source code of this library.
module ROBundle
end
