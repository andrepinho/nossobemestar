class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    
    can :read, :all
    can [:local, :highlighted], Section
    can :click, Ad

    cannot :index, Post
    cannot :index, Region
    cannot :index, Section
    cannot :index, User
    cannot :index, Ad
    cannot :set_highlighted, :home

    unless user.new_record?
      can [:create, :update, :destroy], [Event, Service], user_id: user.id
    end
    can [:events, :services], [User], id: user.id

    if user.region_admin?
      can :manage, Event, region_id: user.region.id
      can :manage, Service, region_id: user.region.id
      can :manage, Ad, region_id: user.region.id
    end

    can :manage, :all if user.admin?

  end
end
