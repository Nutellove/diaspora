module Webocracy
  module DelegationExtension

    def << (delegation)
      case delegation
        when Delegation
          self.push delegation if proxy_association.owner.username == delegation.user.username
        else
          raise "Must pass a Delegation"
      end
    end

  end
end
