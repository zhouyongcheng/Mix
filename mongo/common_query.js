db.user.insert({username: 'demo'});

db.user.find();

db.user.update({username: 'demo'}, {$set : {password: '123456'}});

db.user.update({username: 'demo'}, {$unset: {password: 0}});

db.user.update({username:'demo'}, {$set:{age:15}});

db.user.update({username:'demo'}, {$inc: {age:5}});

db.user.update({username: 'demo'}, {$push : {favorite: 'basketball'}});

db.user.update({username: 'demo'}, {$push : {favorite: 'reading'}});


db.user.update({username: 'demo'}, {$unset : {favorite: 1}});


db.user.update({username: 'demo'}, {$pushAll : {favorite: ['yoga', 'sports']}});

db.user.update({username: 'demo'}, {$addToSet : {game: ['two', 'four']}});