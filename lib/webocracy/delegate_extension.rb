# Make sure we can add either a Person or a User, make sure we don't add ourselves

module Webocracy
  module DelegateExtension

    def << (delegatable)
      case delegatable
        when Person
          self.push delegatable if proxy_association.owner.person.guid != delegatable.guid
        when User
          self.push delegatable.person if proxy_association.owner.guid != delegatable.person.guid
        else
          raise "Must pass a User or a Person"
      end
    end

  end
end
