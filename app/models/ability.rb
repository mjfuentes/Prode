class Ability
  include CanCan::Ability

  def initialize(user)
    # user ||= User.new
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
