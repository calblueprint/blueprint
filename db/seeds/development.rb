# create admin account
puts 'Creating admin user.'
admin_user = User.create(:email => "admin@berk.com", :password => "password", :name => "Badass Admin", :position => "VP of Technology", :year => "2013", :major => "EECS", :is_activated => true, :is_visible => true, :is_admin => true)
puts "\t Created user: #{admin_user.name}."

# create other accounts
users = [
  ["jay@berk.com", "Jae Young Ryoo", "President", 2013, "CS & MCB"],
  ["noel@berk.com", "Noel Moldvai", "VP of Technology", 2013, "EECS"],
  ["shirlz@berk.com", "Shirley Liu", "VP of Marketing & Finance", 2013, "Business"],
  ["kevin@berk.com", "Kevin Gong", "VP of Operations", 2014, "CS"],
  ["kenny@berk.com", "Kenneth Gao", "VP of Projects", 2013, "Bioengineering"],
  ["omer@berk.com", "Omer Spillinger", "Technology Chair", 2013, "EECS"],
  ["alice@berk.com", "Alice Oh", "Marketing Chair", 2014, "Political Economy"],
  ["callmebeautiful@berk.com", "Michelle Chow", "Project Leader", "CS & Business"],
  ["bwong@berk.com", "Brian Wong", "Project Leader", 2013, "CS"],
  ["jp@berk.com", "Joshua Primas", "Project Leader", 2013, "CS"],
  ["dp@berk.com", "David Patterson", "Faculty Advisor"],
  ["fox@berk.com", "Armando Fox", "Faculty Advisor"],
  ["mark@mark.com", "Mark Miyashita", "Project Leader", 2015, "EECS"]
]

puts 'Creating other users.'
users.each do |u|
  new_user = User.create(
    :email => u[0],
    :password => 'password',
    :name => u[1],
    :position => u[2],
    :year => u.length > 2 ? u[3].to_s : '',
    :major => u.length > 3 ? u[4] : '',
    :is_activated => true,
    :is_visible => true
  )
  puts "\t Created user: #{new_user.name}."
end