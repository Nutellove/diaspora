#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# This will manage the propagation of Decisions through the social network
# A citizen asks for the decisions of his delegates, with options :
#   - may bubble up the delegates chain
#   - filter out propositions on which he already has a decision
#   - different conflict managements
module Webocracy
  class DecisionFetcher

    def self.get_from_delegates_of person, options={}
      if person.local?
        Decision.where(:author_id => person.owner.delegates.collect(&:id))
      else
        raise 'TODO' # how ?
      end
    end

    def self.get_from person
      Decision.where(:author_id => person.id)
    end

  end
end