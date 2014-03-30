class App < ActiveRecord::Base
	belongs_to :user

	# model validations
	validates :name, :user_id, presence: true

  validates :user, presence: true

	validates :name, length: { 
		minimum: 2, 
		maximum: 140
	}

	validates :release_note, length: { 
		maximum: 250
	}

	validates :user_id, numericality: {
		only_integer: true
	}
end
