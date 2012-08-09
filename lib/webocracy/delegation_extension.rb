module Webocracy
  module DelegationExtension

    def << (delegatable)
      case delegatable
        when Delegation
          self.push delegatable if proxy_association.owner.username == delegatable.user.username
        when Person
          proxy_association.owner.delegates << delegatable
        when User
          proxy_association.owner.delegates << delegatable.person
        else
          raise "Must pass a Delegation"
      end
    end

  end
end
