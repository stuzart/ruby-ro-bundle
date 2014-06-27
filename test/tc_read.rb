#------------------------------------------------------------------------------
# Copyright (c) 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

require 'test/unit'
require "ro-bundle"

class TestRead < Test::Unit::TestCase

  def test_verify
    assert_nothing_raised(ZipContainer::MalformedContainerError, ZipContainer::ZipError) do
      ROBundle::File.verify!($hello)
    end

    assert(ROBundle::File.verify($hello))
  end

  def test_manifest
    ROBundle::File.open($hello) do |b|
      assert_equal("/", b.id)
    end
  end

end
