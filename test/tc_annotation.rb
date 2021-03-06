#------------------------------------------------------------------------------
# Copyright (c) 2014, 2015 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

require 'test/unit'
require "ro-bundle"

class TestAnnotation < Test::Unit::TestCase

  def setup
    @target = [ "/", "/file.txt" ]
    @content = "http://www.example.com/example.txt"
    @id = UUID.generate(:urn)
    @creator = "Robert Haines"
    @time = "2014-08-20T11:30:00+01:00"

    @json = {
      :about => @target,
      :content => @content,
      :uri => @id,
      :createdBy => { :name => @creator },
      :createdOn => @time
    }
  end

  def test_create
    an = ROBundle::Annotation.new(@target)

    assert_equal @target, an.target
    assert_nil an.content
    assert_not_nil an.uri
    assert an.annotates?("/")
    assert an.annotates?("/file.txt")
    refute an.edited?
  end

  def test_create_with_content
    an = ROBundle::Annotation.new(@target, @content)

    assert_equal @target, an.target
    assert_equal @content, an.content
    assert_not_nil an.uri
    refute an.edited?
  end

  def test_create_from_json
    an = ROBundle::Annotation.new(@json)

    assert_equal @target, an.target
    assert_equal @content, an.content
    assert_equal @id, an.uri
    assert an.created_on.instance_of?(Time)
    assert an.created_by.instance_of?(ROBundle::Agent)
    refute an.edited?
  end

  def test_cannot_change_target_directly
    an = ROBundle::Annotation.new(@json)

    assert_equal 2, an.target.length
    an.target << "/more.html"
    assert_equal 2, an.target.length
    refute an.edited?
    refute an.annotates?("/more.html")
  end

  def test_change_content
    an = ROBundle::Annotation.new(@json)
    new_content = "/file.txt"
    an.content = new_content

    assert_equal new_content, an.content
    assert an.edited?
  end

  def test_generate_annotation_id
    an = ROBundle::Annotation.new(@target)
    id = an.uri

    assert id.instance_of?(String)
    assert id.start_with?("urn:uuid:")
    assert_same id, an.uri
    refute an.edited?
  end

  def test_json_output_single_target
    an = ROBundle::Annotation.new("/")
    json = JSON.parse(JSON.generate(an))

    assert_equal "/", json["about"]
  end

  def test_json_output_multiple_targets
    an = ROBundle::Annotation.new(@target)
    json = JSON.parse(JSON.generate(an))

    assert_equal @target, json["about"]
  end

  def test_full_json_output
    an = ROBundle::Annotation.new(@json)
    json = JSON.parse(JSON.generate(an))

    assert_equal @target, json["about"]
    assert_equal @content, json["content"]
    assert_equal @id, json["uri"]
    assert_equal @time, json["createdOn"]
    assert_equal @creator, json["createdBy"]["name"]
  end

  def test_add_targets
    target1 = "/target.pdf"
    target2 = "/more.html"
    an = ROBundle::Annotation.new(target1)

    assert_equal target1, an.target
    an.add_target(target2)
    assert an.annotates?("/more.html")
    assert_equal [target1, target2], an.target
    an.add_target(@target)
    assert an.annotates?("/")
    assert an.annotates?("/file.txt")
    assert_equal [target1, target2] + @target, an.target
  end

  def test_remove_target
    an = ROBundle::Annotation.new(@json)

    assert an.target.instance_of?(Array)
    assert_equal 2, an.target.length
    rem = an.remove_target("/")
    assert an.edited?
    refute an.annotates?("/")
    assert_equal "/", rem
    assert an.target.instance_of?(String)
    assert_equal "/file.txt", an.target
  end

end
