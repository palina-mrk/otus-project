# drop the pet table if it exists, then recreate it

DROP TABLE IF EXISTS pet;

CREATE TABLE pet(  
  name    VARCHAR(20),
  owner   VARCHAR(20),
  species VARCHAR(20),
  sex     CHAR(1),
  birth   DATE,
  death   DATE
);
INSERT INTO pet values ("Fluffy","Harold","cat",'f',"1993-02-04",NULL);
INSERT INTO pet values ("Claws","Gwen","cat",'m',"1994-03-17",NULL);
INSERT INTO pet values ("Buffy","Harold","dog",'f',"1989-05-13",NULL);
INSERT INTO pet values ("Fang","Benny","dog",'m',"1990-08-27",NULL);
INSERT INTO pet values ("Bowser","Diane","dog",'m',"1979-08-31","1995-07-29");
INSERT INTO pet values ("Chirpy","Gwen","bird",'f',"1998-09-11",NULL);
INSERT INTO pet values ("Whistler","Gwen","bird",NULL,"1997-12-09",NULL);
INSERT INTO pet values ("Slim","Benny","snake",'m',"1996-04-29",NULL);
INSERT INTO pet values ('Puffball','Diane','hamster','f','1999-03-30',NULL);

