class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.administrator?
      can :manage, :all
    else
      can :read, :all
      can :update, User, id: user.id
      can :destroy, Comment, user_id: user.id
      can :create, Comment
    end
  end
end
