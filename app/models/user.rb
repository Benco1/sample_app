class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id",
										class_name: "Relationship",
										# o/w Rails would look for class ReverseRelationships
										dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower
										# source info is omittable in this last line

	before_save { self.email = email.downcase }
	# callback to downcase email before saving to db
	before_create :create_remember_token # 
	# callback with 'method reference' to assign each 
	# new user a remember_token upon (prior to!) creation
	# Assigns to specific user's attributes, hence 'self'
	# (therefore, does NOT become local var, which we don't want!)


	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@(([a-z\d\-]+\.[a-z\d\-]+)|[a-z\d\-]+)\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
						uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end

	def feed
		# Preliminary code (below)
		Micropost.where("user_id = ?", id)
	end

	def User.new_remember_token
		SecureRandom.urlsafe_base64
		# Generates 16 character random string from 64 possible chars
		# from SecureRandom module
	end
	

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
		# Quickly hashes base_64 token; speed is important here 
		# b/c hash will be run on every page for signed-in users
		# .to_s allows for handling of nil tokens, which may occur in tests
	end

	private

		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
		# Defines method for callback to create remember token
		# which will be saved to db
		# Private because method only used within User model

end
