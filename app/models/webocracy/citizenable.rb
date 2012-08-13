#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# Additional methods for User
module Webocracy
  module Citizenable

    def self.included(model)
      model.class_eval do

        has_many :delegations, :class_name => Webocracy::Delegation, :extend => Webocracy::DelegationExtension
        has_many :delegates, :through => :delegations, :source => :person, :extend => Webocracy::DelegateExtension

      end
    end

    def decide!(target, value, opts={})
      find_or_create_participation!(target)
      Decision::Generator.new(self, target).create!(opts.merge(:value => value))
    end

    # Check whether the user has decided on a AbstractPollable.
    # this is a carbon copy of liked?
    def decided_on?(target)
      if target.decisions.loaded?
        self.decision_for(target) ? true : false
      else
        Decision.exists?(:author_id => self.person.id, :target_type => target.class.base_class.to_s, :target_id => target.id)
      end
    end

    # Get the user's decision on an AbstractPollable, if there is one.
    # @return [Decision]
    def decision_for(target)
      if target.decisions.loaded?
        target.decisions.detect{ |decision| decision.author_id == self.person.id }
      else
        Decision.where(:author_id => self.person.id, :target_type => target.class.base_class.to_s, :target_id => target.id).first
      end
    end

    def receives_decision!(decision)
      unless decided_on? decision.target
        if has_as_delegate? decision.author
          decision.target.decisions.create :author => person, :value => decision.value
        end
      end
    end

    def has_as_delegate?(person)
      delegates.include? person
    end




    # unused
    def political_aspect
      aspects.each do |aspect|
        if 'Politics' == aspect.name
          return aspect
        end
      end
      raise "No 'Politics' aspect found."
    end

  end
end
