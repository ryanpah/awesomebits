class User < ActiveRecord::Base
  include Clearance::User
  attr_accessible :first_name, :last_name, :email

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :encrypted_password

  has_many :roles
  has_many :chapters, :through => :roles

  has_many :votes
  has_many :projects, :through => :votes

  def name
    [first_name, last_name].map(&:to_s).join(" ").strip
  end

  def can_manage_chapter?(chapter)
    admin? || roles.can_manage_chapter?(chapter)
  end

  def trustee?
    admin? || roles.any?(&:trustee?)
  end

  def can_manage_permissions?
    admin?
  end

  def can_create_chapters?
    admin?
  end

  def can_invite?
    admin? || roles.can_invite?
  end

  def can_invite_to_chapter?(chapter)
    admin? || roles.can_invite_to_chapter?(chapter)
  end

  def can_view_finalists_for?(chapter)
    admin? || roles.can_view_finalists_for?(chapter)
  end

  def can_mark_winner?(project)
    admin? || roles.can_mark_winner?(project)
  end

end
