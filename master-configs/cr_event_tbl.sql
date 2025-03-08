# drop the event table if it exists, then recreate it

DROP TABLE IF EXISTS event;

CREATE TABLE event
(
  name   VARCHAR(20),
  date   DATE,
  type   VARCHAR(15),
  remark VARCHAR(255)
);
INSERT INTO event VALUES ("Fluffy","1995-05-15","litter","4 kittens, 3 female, 1 male");
INSERT INTO event VALUES ("Buffy","1993-06-23","litter","5 puppies, 2 female, 3 male");
INSERT INTO event VALUES ("Buffy","1994-06-19","litter","3 puppies, 3 female");
INSERT INTO event VALUES ("Chirpy","1999-03-21","vet","needed beak straightened");
INSERT INTO event VALUES ("Slim","1997-08-03","vet","broken rib");
INSERT INTO event VALUES ("Bowser","1991-10-12","kennel",NULL);
INSERT INTO event VALUES ("Fang","1991-10-12","kennel",NULL);
INSERT INTO event VALUES ("Fang","1998-08-28","birthday","Gave him a new chew toy");
INSERT INTO event VALUES ("Claws","1998-03-17","birthday","Gave him a new flea collar");
INSERT INTO event VALUES ("Whistler","1998-12-09","birthday","First birthday");
