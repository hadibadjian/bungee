module ApplicationHelper

	# Return a title on a per-page basis
	def title
		base_title = "Bungee App"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end

	def logo
		image_tag("logo.png", alt: "Bungee App", id: "home_page_logo" )
	end
end
