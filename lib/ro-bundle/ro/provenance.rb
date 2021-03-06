#------------------------------------------------------------------------------
# Copyright (c) 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

#
module ROBundle

  # This module is a mixin for Research Object
  # {provenance}[https://w3id.org/bundle/#provenance] information.
  #
  # To use this module simply provide an (optionally private) method named
  # 'structure' which returns the internal fields of the object as a Hash.
  #
  # Fields added by this mixin are:
  # * <tt>:authoredBy</tt>
  # * <tt>:authoredOn</tt>
  # * <tt>:createdBy</tt>
  # * <tt>:createdOn</tt>
  # * <tt>:retrievedBy</tt>
  # * <tt>:retrievedFrom</tt>
  # * <tt>:retrievedOn</tt>
  module Provenance

    # :call-seq:
    #   add_author(author) -> Agent
    #
    # Add an author to the list of authors for this resource. The
    # supplied parameter can either be an Agent or the name of an author as a
    # String.
    #
    # The Agent object that is added is returned.
    def add_author(author)
      unless author.is_a?(Agent)
        author = Agent.new(author.to_s)
      end

      @edited = true
      (structure[:authoredBy] ||= []) << author
      author
    end

    # :call-seq:
    #   authored_by -> Agents
    #
    # Return the list of Agents that authored this resource.
    def authored_by
      structure.fetch(:authoredBy, []).dup
    end

    # :call-seq:
    #   authored_on -> Time
    #
    # Return the time that this resource was edited as a Time object, or
    # +nil+ if not present in the manifest.
    def authored_on
      Util.parse_time(structure[:authoredOn])
    end

    # :call-seq:
    #   authored_on = new_time
    #
    # Set a new authoredOn time for this resource. Anything that Ruby can
    # interpret as a time is accepted and converted to ISO8601 format on
    # serialization.
    def authored_on=(new_time)
      @edited = true
      set_time(:authoredOn, new_time)
    end

    # :call-seq:
    #   created_by -> Agent
    #
    # Return the Agent that created this resource.
    def created_by
      structure[:createdBy]
    end

    # :call-seq:
    #   created_by = new_creator
    #
    # Set the Agent that has created this resource. Anything passed to this
    # method that is not an Agent will be converted to an Agent before setting
    # the value.
    def created_by=(new_creator)
      unless new_creator.instance_of?(Agent)
        new_creator = Agent.new(new_creator.to_s)
      end

      @edited = true
      structure[:createdBy] = new_creator
    end

    # :call-seq:
    #   created_on -> Time
    #
    # Return the time that this resource was created as a Time object, or
    # +nil+ if not present in the manifest.
    def created_on
      Util.parse_time(structure[:createdOn])
    end

    # :call-seq:
    #   created_on = new_time
    #
    # Set a new createdOn time for this resource. Anything that Ruby can
    # interpret as a time is accepted and converted to ISO8601 format on
    # serialization.
    def created_on=(new_time)
      @edited = true
      set_time(:createdOn, new_time)
    end

    # :call-seq:
    #   remove_author(name)
    #   remove_author(Agent)
    #
    # Remove the specified author or all authors with the specified name from
    # the +authoredBy+ field.
    def remove_author(object)
      if object.is_a?(Agent)
        structure[:authoredBy].delete(object)
        @edited = true
      else
        changed = structure[:authoredBy].reject! { |a| a.name == object }
        @edited = true unless changed.nil?
      end
    end

    # :call-seq:
    #   retrieved_by -> Agent
    #
    # Return the Agent that retrieved this resource.
    def retrieved_by
      structure[:retrievedBy]
    end

    # :call-seq:
    #   retrieved_by = new_retrievor
    #
    # Set the Agent that has retrieved this resource. Anything passed to this
    # method that is not an Agent will be converted to an Agent before setting
    # the value.
    def retrieved_by=(new_retrievor)
      unless new_retrievor.instance_of?(Agent)
        new_retrievor = Agent.new(new_retrievor.to_s)
      end

      @edited = true
      structure[:retrievedBy] = new_retrievor
    end

    # :call-seq:
    #   retrieved_from -> String URI
    #
    # Return the URI from which this resource was retrieved.
    def retrieved_from
      structure[:retrievedFrom]
    end

    # :call-seq:
    #   retrieved_from = uri
    #
    # Set the URI from which this resource was retrieved. If a URI object is
    # given it is converted to a String first.
    def retrieved_from=(uri)
      return unless Util.is_absolute_uri?(uri)

      @edited = true
      structure[:retrievedFrom] = uri.to_s
    end

    # :call-seq:
    #   retrieved_on -> Time
    #
    # Return the time that this resource was retrieved as a Time object, or
    # +nil+ if not present in the manifest.
    def retrieved_on
      Util.parse_time(structure[:retrievedOn])
    end

    # :call-seq:
    #   retrieved_on = new_time
    #
    # Set a new retrievedOn time for this resource. Anything that Ruby can
    # interpret as a time is accepted and converted to ISO8601 format on
    # serialization.
    def retrieved_on=(new_time)
      @edited = true
      set_time(:retrievedOn, new_time)
    end

    private

    def init_provenance_defaults(struct)
      creator = struct[:createdBy]
      struct[:createdBy] = Agent.new(creator) unless creator.nil?
      struct[:authoredBy] = [*struct.fetch(:authoredBy, [])].map do |agent|
        Agent.new(agent)
      end
      retrievor = struct[:retrievedBy]
      struct[:retrievedBy] = Agent.new(retrievor) unless retrievor.nil?

      struct
    end

    def set_time(key, time)
      if time.instance_of?(String)
        time = Time.parse(time)
      end

      structure[key] = time.iso8601
    end

  end

end
