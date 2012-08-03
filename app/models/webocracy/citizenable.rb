#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# Additional methods for User
module Webocracy
  module Citizenable

    def self.included(model)
      model.class_eval do

        has_many :delegations, :class_name => Webocracy::Delegation, :extend => Webocracy::DelegationExtension
        has_many :delegates, :through => :delegations, :source => :person

      end
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
