class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  has_many :following, through: :relationships, source: :followed
  has_many :followers, through: :relationships, source: :follower
  
  attachment :profile_image

  validates :name, presence: true, length: { in: 2..20}
  validates :introduction, length: {maximum: 50}
  
  def follow(other_user)
    following << other_user
  end

  
  def unfollow(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end


  def following?(other_user)
    following.include?(other_user)
  end
  
  
end
