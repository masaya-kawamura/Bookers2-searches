class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,     dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments,  dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                 foreign_key: 'follower_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship',
                                  foreign_key: 'followed_id',
                                    dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  attachment :profile_image

  validates :name, presence: true, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}

  # ユーザーをフォローするメソッド
  def follow(other_user)
    following << other_user
  end

  # ユーザーのフォロー解除
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーをフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # 検索機能のlooksメソッド定義
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where('name LIKE?', "#{word}")
    elsif search == "forward_match"
      @user = User.where('name LIKE?', "#{word}%")
    elsif search == 'backword_match'
      @user = User.where('name LIKE?', "%#{word}")
    elsif search == 'partial_match'
      @user = User.where('name LIKE?', "%#{word}%")
    else
      @user = User.all
    end
  end

end
