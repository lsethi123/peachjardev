class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :dp_token
  has_and_belongs_to_many :share_links
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  	validates :username, presence: true
	validates :username, uniqueness: true, if: -> { self.username.present? }
end
