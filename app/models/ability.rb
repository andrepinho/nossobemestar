class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    
    can :read, :all
    can [:local, :highlighted], Section

    cannot :index, Post
    cannot :index, Region
    cannot :index, Section

    can [:create, :update], [Event, Service], user_id: user.id

    can :manage, :all if user.admin?

  end
end
