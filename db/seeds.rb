
users = [
    {fname: 'Jon', lname: 'Doe', email: 'jdoe@example.com'},
    {fname: 'Jane', lname: 'Kate', email: 'jkate@example.com'}
]

users.each do |u|
  User.create(u)
end
