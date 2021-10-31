CREATE TABLE if NOT EXISTS police_shop (
  id int(11) NOT NULL,
  name varchar(255) DEFAULT NULL,
  display varchar(255) DEFAULT NULL,
  type varchar(255) DEFAULT NULL,
  price int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into police_shop (id, name, display, type, price) Values
(1, 'bulletproof', 'bulletproof', 'item', 500)