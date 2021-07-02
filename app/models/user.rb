class User < ApplicationRecord
  before_create :create_profile

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :profile, dependent: :destroy

  # used to persist current user in native app
  def remember_me
    (super == nil) ? '1' : super
  end

  private

  def create_profile
    self.build_profile
  end
end
