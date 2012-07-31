#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# A YesNo%MaybePollable entity will receive Decisions from Citizens.
# These Decisions must hold values in {-1,0,1} or an exception will be raised
module Webocracy
  module YesNoMaybePollable
    include Webocracy::Pollable

    def self.included(model)
      make_pollable model

      model.instance_eval do

        include InstanceMethods

      end




    end

    module InstanceMethods

      def << (decision)
        case decision
          when Decision
            raise "Decision has not valid values" unless is_valid decision
            self.decisions << decision
          else
            raise "Unknown decision type '#{decision.class.base_class.to_s}'"
        end
      end

    end


    # Make sure added decisions' values are -1, 0 or 1
    def is_valid(decision)
      return true
      -1 >= decision.value && decision.value <= 1
    end
  end
end
