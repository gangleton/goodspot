class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  has_many :phone_numbers

  ROLES = %w[author moderator admin]
  VERIFICATION_CODE = "sflgbtcenter"

  before_create :set_role

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def set_role
    role = "author" if role.nil?
  end

  def verified?
    verified
  end

  def verify!(code)
    if code == VERIFICATION_CODE
      self.verified = true
      self.role = 'author'
      if self.save
        true
      else
        false
      end
    else
      false
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20]
                           )
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
