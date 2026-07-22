User.find_or_create_by!(email: "test@example.com") do |user|
  user.password = "password"
end
