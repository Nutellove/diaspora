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

    #def decide!(target, value, opts={})
    #  find_or_create_participation!(target)
    #  Decision::Generator.new(self, target).create!(opts.merge(:value => value))
    #end

    # handy alias
    def vote(target, value, opts={})
      person.vote opts.merge(:votable => target, :value => value)
    end

    # Check whether the user has voted on a Votable.
    def voted_on?(target)
      target.voted_on_by? person
    end

    # Get the user's Vote on an Votable, if there is one.
    # @return Vote
    def find_vote_on(target)
      target.vote_of person
    end
    alias :find_vote_for :find_vote_on

    # Inherits the passed vote if it comes from a delegate
    def receives_vote!(vote)
      unless voted_on? vote.votable
        if has_as_delegate? vote.voter
          success = vote.votable.vote :voter => person, :value => vote.value, :delegate => vote.voter
          if success
            new_vote = person.find_vote_on vote.votable
            new_vote.delegate = vote.voter
            return new_vote.save
          end
          return success
        end
      end
      false
    end

    def has_as_delegate?(person)
      delegates.include? person
    end




    # unused
    #def political_aspect
    #  aspects.each do |aspect|
    #    if 'Politics' == aspect.name
    #      return aspect
    #    end
    #  end
    #  raise "No 'Politics' aspect found."
    #end

  end
end
