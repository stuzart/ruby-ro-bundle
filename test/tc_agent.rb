#------------------------------------------------------------------------------
# Copyright (c) 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

require 'test/unit'
require "ro-bundle"

class TestAgent < Test::Unit::TestCase

  def setup
    @name = "Robert Haines"
    @uri = "https://github.com/hainesr"
    @orcid = "http://orcid.org/0000-0002-9538-7919"

    @json = { :name => @name, :uri => @uri, :orcid => @orcid }
  end

  def test_create_from_json_hash
    agent = ROBundle::Agent.new(@json)

    assert_equal @name, agent.name
    assert_equal @uri, agent.uri
    assert_equal @orcid, agent.orcid
  end

  def test_create_from_empty_json_hash
    agent = ROBundle::Agent.new({})

    assert_nil agent.name
    assert_nil agent.uri
    assert_nil agent.orcid
  end

  def test_create_from_parameters
    agent = ROBundle::Agent.new(@name, @uri, @orcid)

    assert_equal @name, agent.name
    assert_equal @uri, agent.uri
    assert_equal @orcid, agent.orcid
  end

  def test_create_from_parameters_with_uris
    agent = ROBundle::Agent.new(@name, URI.parse(@uri), URI.parse(@orcid))

    assert_equal @name, agent.name
    assert_equal @uri, agent.uri
    assert_equal @orcid, agent.orcid
  end

  def test_json_output
    agent = ROBundle::Agent.new(@json)
    json = JSON.parse(JSON.generate(agent))

    assert_equal @name, json["name"]
    assert_equal @uri, json["uri"]
    assert_equal @orcid, json["orcid"]
  end

end
