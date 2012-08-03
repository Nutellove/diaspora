#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# Additional methods for User
module Webocracy
  module Citizenable

    def delegates
      a = []
      aspects.each do |aspect|
        if 'Politics' == aspect.name
          aspect.contacts.each do |contact|
            a << contact.person
          end
        end
      end
      a
    end

  end
end
