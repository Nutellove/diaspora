module Webocracy
  module DelegateExtension

    def << (delegatable)
      case delegatable
        when Person
          self.push delegatable if proxy_association.owner.username != delegatable.user.username
        when User
          self.push delegatable.person if proxy_association.owner.username != delegatable.username
        else
          raise "Must pass a User or Person"
      end
    end

  end
end
