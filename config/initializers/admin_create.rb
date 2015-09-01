if !(Player.find_by admin: true)
	@admin = Player.new(name: 'admin',username: 'admin', password: 'admin', email: 'admin', admin: true)
	@admin.save
end