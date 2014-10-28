class Ability
  include CanCan::Ability
   def initialize(user)
       can :read, :all
      if user.has_role? :super_admin
       can :manage, :all
     elsif user.has_role? :admin
      can :access, :rails_admin
      can :dashboard
     end
   end
 end
