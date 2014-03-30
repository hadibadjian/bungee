class User < ActiveRecord::Base
	has_many :apps

	validates_associated :apps

  validates :name, :email, presence: true

	validates :name, length: { 
		maximum: 140 
	}

	validates :email, uniqueness: {
		case_sensitive: false
	}
end
