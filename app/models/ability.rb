class Ability
  include CanCan::Ability

  def initialize(user)
    if user 
      if user.admin?
          can :manage, :all
          cannot :manage, Guess
      else
          can :read, Matchday
          can :manage, Guess
      end
    end
  end
end
