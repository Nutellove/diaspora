#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# Additional methods for User
module Webocracy
  module Citizenable

    def delegates
      def << (person)
        raise "TEST"
      end
      return @delegates unless @delegates.blank?
      political_aspect.contacts.collect do |contact|
        contact.person
      end
    end

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
