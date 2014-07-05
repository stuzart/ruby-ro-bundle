#------------------------------------------------------------------------------
# Copyright (c) 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

require 'test/unit'
require "ro-bundle"

class TestAnnotation < Test::Unit::TestCase

  def setup
    @about = [ "/", "/file.txt" ]
    @content = "http://www.example.com/example.txt"
    @id = UUID.generate(:urn)

    @json = {
      :about => @about,
      :content => @content,
      :annotation => @id
    }
  end

  def test_create
    an = ROBundle::Annotation.new(@about)

    assert_equal @about, an.about
    assert_nil an.content
    assert_not_nil an.annotation_id
  end

  def test_create_with_content
    an = ROBundle::Annotation.new(@about, @content)

    assert_equal @about, an.about
    assert_equal @content, an.content
    assert_not_nil an.annotation_id
  end

  def test_create_from_json
    an = ROBundle::Annotation.new(@json)

    assert_equal @about, an.about
    assert_equal @content, an.content
    assert_equal @id, an.annotation_id
  end

  def test_generate_annotation_id
    an = ROBundle::Annotation.new(@about)
    id = an.annotation_id

    assert id.instance_of?(String)
    assert id.start_with?("urn:uuid:")
    assert_same id, an.annotation_id
  end

  def test_json_output
    agent = ROBundle::Annotation.new(@json)
    json = JSON.parse(JSON.generate(agent))

    assert_equal @about, json["about"]
    assert_equal @content, json["content"]
    assert_equal @id, json["annotation"]
  end

end
