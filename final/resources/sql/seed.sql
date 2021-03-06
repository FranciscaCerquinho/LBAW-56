DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS admin CASCADE;
DROP TABLE IF EXISTS bid CASCADE;
DROP TABLE IF EXISTS auction CASCADE;
DROP TABLE IF EXISTS comment CASCADE;
DROP TABLE IF EXISTS reportUser CASCADE;
DROP TABLE IF EXISTS reportAuction CASCADE;
DROP TABLE IF EXISTS banUser CASCADE;
DROP TABLE IF EXISTS banAuction CASCADE;
DROP TABLE IF EXISTS "owner" CASCADE;
DROP TABLE IF EXISTS wishList CASCADE;
DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS buyNow CASCADE;
DROP TABLE IF EXISTS cards CASCADE;
DROP TABLE IF EXISTS items CASCADE;
DROP TABLE IF EXISTS userAuctionLike CASCADE;
DROP TABLE IF EXISTS userCommentLike CASCADE;
DROP TABLE IF EXISTS endAuction CASCADE;

DROP FUNCTION IF EXISTS "CheckAuctionDate"() CASCADE;
DROP TRIGGER IF EXISTS "CheckAuctionDate" ON bid CASCADE;
DROP FUNCTION IF EXISTS "CheckUserBid"() CASCADE;
DROP FUNCTION IF EXISTS "CheckUserBuyNow"() CASCADE;
DROP TRIGGER IF EXISTS "CheckUserBid" ON bid CASCADE;
DROP TRIGGER IF EXISTS "CheckUserBuyNow" ON buyNow CASCADE;
DROP FUNCTION IF EXISTS "CheckReportedUserNotAdmin"() CASCADE;
DROP TRIGGER IF EXISTS "ReportedUserNotAdmin" ON reportuser CASCADE;
DROP FUNCTION IF EXISTS "CheckReportingNotAuctionOwner"() CASCADE;
DROP TRIGGER IF EXISTS "ReportingNotOwner" ON reportAuction CASCADE;



CREATE TABLE users(
  user_id SERIAL NOT NULL,
  email text NOT NULL UNIQUE,
  password text NOT NULL,
  firstName text NOT NULL,
  lastName text NOT NULL,
  photo text,
  address text,
  country text,
  contact NUMERIC,
  remember_token text,
  isBanned BOOLEAN NOT NULL
);

CREATE TABLE admin(
  id SERIAL NOT NULL,
  id_user INTEGER NOT NULL
);

CREATE TABLE bid(
  id SERIAL NOT NULL,
  status BOOLEAN NOT NULL,
  price FLOAT,
  date  TIMESTAMP WITH TIME zone DEFAULT now() NOT NULL,
  bid_id_auction INTEGER NOT NULL,
  bid_id_user INTEGER NOT NULL
);

CREATE TABLE auction (
  auction_id SERIAL NOT NULL,
  dateBegin  TIMESTAMP WITH TIME zone DEFAULT now() NOT NULL,
  dateEnd  TIMESTAMP WITH TIME zone NOT NULL,
  name text NOT NULL,
  description text,
  actualPrice double precision NOT NULL,
  auctionPhoto text NOT NULL,
  buynow double precision NOT NULL,
  active boolean NOT NULL,
  auction_like INTEGER,
  auction_dislike INTEGER
);

CREATE TABLE userAuctionLike(
    islike boolean NOT NULL,
    id_user INTEGER NOT NULL,
    id_auction INTEGER NOT NULL
);

CREATE TABLE comment(
  id SERIAL NOT NULL,
  "like" INTEGER,
  dislike INTEGER,
  date TIMESTAMP WITH TIME zone DEFAULT now() NOT NULL,
  comment text NOT NULL,
  id_user INTEGER NOT NULL,
  id_auction INTEGER NOT NULL,
  available boolean NOT NULL
);

CREATE TABLE userCommentLike(
    islike boolean NOT NULL,
    id_user INTEGER NOT NULL,
    id_comment INTEGER NOT NULL
);
CREATE TABLE reportUser(
  id SERIAL NOT NULL,
  reason text NOT NULL,
  id_userReporting INTEGER NOT NULL,
  id_userReported INTEGER NOT NULL,
  date TIMESTAMP WITH TIME zone DEFAULT now() NOT NULL
);

CREATE TABLE reportAuction(
  id SERIAL NOT NULL,
  id_user INTEGER NOT NULL,
  id_auction INTEGER NOT NULL,
  reason text NOT NULL,
  date TIMESTAMP WITH TIME zone DEFAULT now() NOT NULL
);

CREATE TABLE banUser(
  id SERIAL NOT NULL,
  id_user INTEGER NOT NULL,
  id_admin  INTEGER NOT NULL,
  date  TIMESTAMP WITH TIME zone DEFAULT now() NOT NULL
);

CREATE TABLE banAuction(
  id SERIAL NOT NULL,
  id_user INTEGER NOT NULL,
  id_auction INTEGER NOT NULL,
  date  TIMESTAMP WITH TIME zone DEFAULT now() NOT NULL
);

CREATE TABLE "owner"(
  id SERIAL NOT NULL,
  id_user INTEGER NOT NULL,
  id_auction INTEGER NOT NULL
);

CREATE TABLE wishList(
  wishlist_id SERIAL NOT NULL,
  user_id INTEGER NOT NULL,
  auction_id INTEGER NOT NULL,
  "date" TIMESTAMP WITH TIME zone DEFAULT now() NOT NULL
);

CREATE TABLE category(
    id SERIAL NOT NULL,
    id_auction INTEGER NOT NULL,
    CATEGORY text NOT NULL,
    CONSTRAINT TYPE CHECK ((CATEGORY = ANY (ARRAY['Electronics'::text, 'Fashion'::text, 'Home & Garden'::text, 'Motors'::text, 'Music'::text, 'Toys'::text, 'Daily Deals'::text, 'Sporting'::text, 'Others'::text]))));

CREATE TABLE buyNow(
  id SERIAL NOT NULL,
  id_user INTEGER NOT NULL,
  id_auction INTEGER NOT NULL
);

CREATE TABLE endAuction(
  endAuction_id SERIAL NOT NULL,
  id_user INTEGER NOT NULL,
  id_auction INTEGER NOT NULL,
  "status" boolean NOT NULL
);


-- Primary Keys and Uniques

ALTER TABLE ONLY users
  ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);

ALTER TABLE ONLY admin
  ADD CONSTRAINT admin_pkey PRIMARY KEY (id,id_user);

ALTER TABLE ONLY auction
  ADD CONSTRAINT auction_pkey PRIMARY KEY (auction_id);

ALTER TABLE ONLY userAuctionLike
  ADD CONSTRAINT userAuctionLike_pkey PRIMARY KEY (id_user, id_auction);

ALTER TABLE ONLY bid
  ADD CONSTRAINT bid_pkey PRIMARY KEY (id);

ALTER TABLE ONLY comment
  ADD CONSTRAINT comment_pkey PRIMARY KEY (id);

ALTER TABLE ONLY userCommentLike
  ADD CONSTRAINT userCommentLike_pkey PRIMARY KEY (id_user, id_comment);

ALTER TABLE ONLY reportUser
  ADD CONSTRAINT reportUser_pkey PRIMARY KEY (id);

ALTER TABLE ONLY reportAuction
  ADD CONSTRAINT reportAuction_pkey PRIMARY KEY (id);

ALTER TABLE ONLY banUser
  ADD CONSTRAINT banUser_pkey PRIMARY KEY (id);

ALTER TABLE ONLY banAuction
  ADD CONSTRAINT banAuction_pkey PRIMARY KEY (id);

ALTER TABLE ONLY owner
  ADD CONSTRAINT owner_pkey PRIMARY KEY (id_user, id_auction);

ALTER TABLE ONLY wishList
  ADD CONSTRAINT wishList_pkey PRIMARY KEY (wishlist_id);

ALTER TABLE ONLY buyNow
  ADD CONSTRAINT buynow_pkey PRIMARY KEY (id);

ALTER TABLE ONLY endAuction
  ADD CONSTRAINT endAuction_pkey PRIMARY KEY (endAuction_id);


-- Foreign Keys

ALTER TABLE ONLY admin
    ADD CONSTRAINT admin_id_auction_fkey FOREIGN KEY (id_user) REFERENCES users(user_id);

ALTER TABLE ONLY banauction
    ADD CONSTRAINT banauction_id_auction_fkey FOREIGN KEY (id_auction) REFERENCES auction(auction_id);

ALTER TABLE ONLY banauction
    ADD CONSTRAINT banauction_id_user_fkey FOREIGN KEY (id_user) REFERENCES users(user_id);

ALTER TABLE ONLY userAuctionLike
    ADD CONSTRAINT userAuctionLike_id_user_fkey FOREIGN KEY (id_user) REFERENCES users(user_id);

ALTER TABLE ONLY userAuctionLike
    ADD CONSTRAINT userAuctionLike_id_auction_fkey FOREIGN KEY (id_auction) REFERENCES auction(auction_id);

ALTER TABLE ONLY banuser
    ADD CONSTRAINT banuser_id_user_fkey FOREIGN KEY (id_user) REFERENCES users(user_id);

ALTER TABLE ONLY bid
    ADD CONSTRAINT bid_id_auction_fkey FOREIGN KEY (bid_id_auction) REFERENCES auction(auction_id);

ALTER TABLE ONLY bid
    ADD CONSTRAINT bid_id_user_fkey FOREIGN KEY (bid_id_user) REFERENCES users(user_id);

ALTER TABLE ONLY category
    ADD CONSTRAINT category_id_auction_fkey FOREIGN KEY (id_auction) REFERENCES auction(auction_id);

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_id_auction_fkey FOREIGN KEY (id_auction) REFERENCES auction(auction_id);

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_id_user_fkey FOREIGN KEY (id_user) REFERENCES users(user_id);

ALTER TABLE ONLY userCommentLike
    ADD CONSTRAINT userCommentLike_id_user_fkey FOREIGN KEY (id_user) REFERENCES users(user_id);

ALTER TABLE ONLY userCommentLike
    ADD CONSTRAINT userCommentLike_id_comment_fkey FOREIGN KEY (id_comment) REFERENCES comment(id);

ALTER TABLE ONLY owner
    ADD CONSTRAINT owner_id_auction_fkey FOREIGN KEY (id_auction) REFERENCES auction(auction_id);

ALTER TABLE ONLY owner
    ADD CONSTRAINT owner_id_user_fkey FOREIGN KEY (id_user) REFERENCES users(user_id);

ALTER TABLE ONLY reportauction
    ADD CONSTRAINT reportauction_id_auction_fkey FOREIGN KEY (id_auction) REFERENCES auction(auction_id);

ALTER TABLE ONLY reportauction
    ADD CONSTRAINT reportauction_id_user_fkey FOREIGN KEY (id_user) REFERENCES users(user_id);

ALTER TABLE ONLY reportuser
    ADD CONSTRAINT reportinguser_id_user_fkey FOREIGN KEY (id_userReporting) REFERENCES users(user_id);

ALTER TABLE ONLY reportuser
    ADD CONSTRAINT reporteduser_id_user_fkey FOREIGN KEY (id_userReported) REFERENCES users(user_id);

ALTER TABLE ONLY wishlist
    ADD CONSTRAINT wishlist_id_auction_fkey FOREIGN KEY (auction_id) REFERENCES auction(auction_id);

ALTER TABLE ONLY wishlist
    ADD CONSTRAINT wishlist_id_user_fkey FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE ONLY buynow
    ADD CONSTRAINT buynow_id_auction_fkey FOREIGN KEY (id_auction) REFERENCES auction(auction_id);

ALTER TABLE ONLY buynow
    ADD CONSTRAINT buynow_id_user_fkey FOREIGN KEY (id_user) REFERENCES users(user_id);

ALTER TABLE ONLY endAuction
    ADD CONSTRAINT endAuction_id_auction_fkey FOREIGN KEY (id_auction) REFERENCES auction(auction_id);

ALTER TABLE ONLY endAuction
    ADD CONSTRAINT endAuction_id_user_fkey FOREIGN KEY (id_user) REFERENCES users(user_id);

-- INDEXES
CREATE INDEX email_user ON "users" USING hash (email);
CREATE INDEX auctions ON auction USING hash (auction_id);
CREATE INDEX wishList_auction ON wishList USING hash (auction_id);
CREATE INDEX auction_comments ON comment USING hash (id_auction);

-- TRIGGERS and UDFs
CREATE FUNCTION "CheckAuctionDate"() RETURNS trigger
   LANGUAGE plpgsql
   AS $$
DECLARE
   auctionDateEnd date;
BEGIN
   SELECT auction.dateEnd INTO auctionDateEnd FROM auction WHERE auction.auction_id = NEW.bid_id_auction;
   IF auctionDateEnd < NEW.date THEN
       RAISE EXCEPTION 'Cannot bid on closed auction!';
   END IF;
   RETURN NEW;
END;
$$;

CREATE TRIGGER "CheckAuctionDate"
   BEFORE INSERT ON bid
   FOR EACH ROW
       EXECUTE PROCEDURE "CheckAuctionDate"();

CREATE FUNCTION "CheckUserBid"() RETURNS trigger
   LANGUAGE plpgsql
   AS $$
DECLARE
   sellerId integer;
BEGIN
   SELECT owner.id_user INTO sellerId FROM owner WHERE owner.id_auction = NEW.bid_id_auction;

   IF NEW.bid_id_user = sellerId THEN
       RAISE EXCEPTION 'Cannot have the same buyer as its seller!';
   END IF;
   RETURN NEW;
END;
$$;

CREATE TRIGGER "CheckUserBid"
   BEFORE INSERT ON bid
   FOR EACH ROW
       EXECUTE PROCEDURE "CheckUserBid"();

CREATE FUNCTION "CheckUserBuyNow"() RETURNS trigger
   LANGUAGE plpgsql
   AS $$
DECLARE
   sellerId INTEGER;
BEGIN
   SELECT owner.id_user INTO sellerId FROM owner WHERE owner.id_auction = NEW.id_auction;
   IF NEW.id_user = sellerId THEN
       RAISE EXCEPTION 'Cannot have the same buyer as its seller!';
   END IF;
   RETURN NEW;
END;
$$;

CREATE TRIGGER "CheckUserBuyNow"
   BEFORE INSERT ON buyNow
   FOR EACH ROW
       EXECUTE PROCEDURE "CheckUserBuyNow"();


CREATE FUNCTION "CheckReportedUserNotAdmin"() RETURNS trigger
   LANGUAGE plpgsql
   AS $$
DECLARE
   adminCount integer;
BEGIN
   SELECT count(*) INTO adminCount FROM admin WHERE admin.id_user = NEW.id_userReported;
   IF adminCount > 0 THEN
       RAISE EXCEPTION 'Cannot report an admin!';
   END IF;
   RETURN NEW;
END;
$$;

CREATE TRIGGER "ReportedUserNotAdmin"
   BEFORE INSERT ON reportuser
   FOR EACH ROW
       EXECUTE PROCEDURE "CheckReportedUserNotAdmin"();

CREATE FUNCTION "CheckReportingNotAuctionOwner"() RETURNS trigger
   LANGUAGE plpgsql
   AS $$
DECLARE
   idOwner integer;
BEGIN
   SELECT owner.id_user INTO idOwner FROM auction, owner WHERE auction.auction_id = owner.id_auction AND auction.auction_id = NEW.id_auction;
   IF idOwner = NEW.id_user THEN
       RAISE EXCEPTION 'Cannot report own auction!';
   END IF;
   RETURN NEW;
END;
$$;

CREATE TRIGGER "ReportingNotOwner"
BEFORE INSERT ON reportAuction
FOR EACH ROW
EXECUTE PROCEDURE "CheckReportingNotAuctionOwner"();



INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('João', 'Silva','joaosilva@hotmail.com','perfil_blue.png','Avenida dos Aliados 700',16954062003699,'Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Teresa', 'Sá','tsa@gmail.com','perfil_blue.png','Rua de Fez 308',16761061088899,'Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Henrique', 'Trigueiros','htrigueiros@hotmail.com','perfil_blue.png','Rua António Cardoso 28',16101242675199,'Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Dinis', 'Lopes','dinis.lopes@sapo.pt','perfil_blue.png','Avenida da Boavista 108',16080251457399,'Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Teresa', 'Ramos','ttramos@gmail.com','perfil_blue.png','Rua de Sintra 798',16736041004499,'Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Eduardo', 'Azevedo','eduardo_azevedo@hotmail.com','perfil_blue.png','Rua da Quinta 24',16400826496996,'Porto,Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Francisca', 'Santos','fsantos@hotmail.com','perfil_blue.png','Rua da Estrada 29',16040421975299,'Porto, Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Phillip', 'Mathis','phillipMathis@gmail.com','perfil_blue.png','4576 Mauris Ave',16361003936599,'Virgin Islands, British','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Joana', 'Torrinha','jtorrinha@hotmail.com','perfil_blue.png','Rua de Fez 46',16961122182999,'Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',true);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Joel', 'David','joel_david@hotmail.com','perfil_blue.png','Ap #284-6045 Tortor, St.',16010122315299,'Trinidad and Tobago','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Sophia', 'Clark','shopia22@gmail.com','perfil_blue.png','P.O. Box 550, 6334 Elit, Av.',16235031958499,'Mali','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Madeson', 'Velasquez','madeson87@hotmail.com','perfil_blue.png','P.O. Box 948, 2265 Sem Avenue',16790628317299,'Spain','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',true);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Eagan', 'Hampton','eagan_hampton@gmail.com','perfil_blue.png','Ap #961-7290 Amet, Street',16520402529799,'Uzbekistan','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Joshua', 'Camacho','joshua65@hotmail.com','perfil_blue.png','P.O. Box 657, 8909 Taciti St.',16650030671099,'Dominican Republic','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Halla', 'Langley','halla_langley@gmail.com','perfil_blue.png','2051 Fusce Road',16570512533899,'Chile','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Burton', 'Stuart','burton_stuart@hotmail.com','perfil_blue.png','356 Nostra, Av.',16510540764799,'United Kingdom (Great Britain)','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Yoshio', 'Chan','yoshionchan21@gmail.com','perfil_blue.png','7528 Amet St.',16520222583799,'Kuwait','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Carson', 'Hansen','carson_hansen@hotmail.com','perfil_blue.png','P.O. Box 238, 9874 Varius St.',16210660785099,'Bahamas','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Tyler', 'Callahan','tyler_callahan@hotmail.com','perfil_blue.png','Ap #450-1601 Varius Avenue',16570751541099,'Jordan','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Tess', 'Walton','tess@gmail.com','perfil_blue.png','423-8125 Felis, Avenue',16430501642699,'Antarctica','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('John', 'Smith','john_smith@gmail.com','perfil_blue.png','724-8471 Ullamcorper, Rd.',16361030768299,'Argentina','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Rajah', 'Santana','non.nisi@gmail.com','perfil_blue.png','P.O. Box 654, 8869 Velit Av.',16900408827499,'Cambodia','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Elizabeth', 'Doyle','felis@gmail.com','perfil_blue.png','Ap #824-1976 Arcu Av.',16011213032299,'Bahamas','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Ingrid', 'Shelton','ingrid_shelton@gmail.com','perfil_blue.png','738-1932 Tortor Rd.',16463070322799,'Latvia','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',true);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Colleen', 'Hoover','collen.hoover@gmail.com','perfil_blue.png','1135 Metus. St.',16031030131599,'Grenada','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Harry', 'Alvarado','harry_alvarado@gmail.com','perfil_blue.png','Ap #357-8402 Faucibus Road',16154123077799,'Mali','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Meghan', 'Hopper','meghan_hopeer@gmail.com','perfil_blue.png','767-1240 Donec Street',16170511950199,'El Salvador','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Jenny', 'Jennings','jenny@gmail.com','perfil_blue.png','Ap #192-5474 Pretium Street',16240531568799,'Georgia','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Julie', 'Ross','julie.ross@gmail.com','perfil_blue.png','Ap #755-9925 Purus Avenue',16490591007299,'Zimbabwe','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',true);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Fernando', 'Cassola','fcassola@fe.up.pt','perfil_blue.png','Rua da Batalha',00351937563986,'Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Francisca', 'Cerquinho','up201505791@fe.up.pt','perfil_blue.png','Rua da Batalha',00351937563986,'Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Diogo', 'Silva','up201405742@fe.up.pt','perfil_blue.png','Rua da Batalha',00351937563986,'Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('José', 'Azevedo','up201506448@fe.up.pt','perfil_blue.png','Rua da Batalha',00351937563986,'Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);
INSERT INTO users (firstName,lastName,email,photo,address,contact,country,password,remember_token,isBanned) VALUES ('Pedro', 'Miranda','pedro21fcp@gmail.com','perfil_blue.png','Rua Nova da Gandra',00351961835740,'Portugal','$2y$10$IqWEImbQM5N4nIEMzWH4f.AJUYrmN7n2SkOgTDQCsB7.lj0.XMOPC','a7Exqf7pDTL7JSQ8hGGeQzzfLHbuedsXhdbgzVuCL3iewX9aQhpQ0sdveM0b',false);

INSERT INTO admin (id_user) VALUES (30);
INSERT INTO admin (id_user) VALUES (31);
INSERT INTO admin (id_user) VALUES (32);
INSERT INTO admin (id_user) VALUES (33);

INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-13 00:00:00','2018-07-03 10:51:25','PS4 Controllers','Two Sony PS4 controllers that were only used once.',50.99,'play.jpg',70,'1',12,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-26 00:00:00','2018-07-05 10:17:00','Phone','The new one! Two good to be true! Buy now!',280.00,'phone.jpg',350.50,'1',10,0);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-20 00:00:00','2018-07-02 00:00:00','MacbookPro','The new MacbookPro, 13 polg.',1000.99,'macbook.jpg',1500.10,'1',8,2);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-14 00:00:00','2018-07-22 00:00:00','Iphone7','The new iphone 7 with 64GB.',700.50,'iphone.jpg',750.60,'1',15,0);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-13 00:00:00','2018-07-12 00:00:00','New Album David Bowie','The new album from david bowie. Good conditions',20.90,'music.jpg',25.50,'1',12,3);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-05 00:00:00','2018-07-20 00:00:00','Vinyl Mike Evans','The album from Mike Evans.',25.90,'music2.jpg',27.00,'1',14,3);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-08 00:00:00','2018-07-03 01:06:00','Vinyl','The new Vynil! Buy now.',30.22,'music3.jpg',36.84,'1',13,2);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-20 00:00:00','2018-07-06 00:00:00','Camera Nikon D7500','The new Nikon camera!',468.41,'camera.jpg',500.62,'1',2,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-04 00:00:00','2018-07-06 00:00:00','New Camera','The new one.Buy now!',26.00,'camera2.jpg',30.66,'1',6,2);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-01 00:00:00','2018-07-02 00:00:00','Tennis Nike','The new Tennis from nike!',96.00,'sport.jpg',100.00,'1',2,3);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-15 00:00:00','2018-07-08 00:00:00','QUAY AUSTRALIA Sunglasses','The new blue sunglasses!',90.92,'sunglasses.jpg',92.40,'1',16,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-03 00:00:00','2018-07-05 00:00:00','Prada Cameo Saffiano','The new fashion!',500.49,'prada.jpg',520.05,'1',5,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-10 00:00:00','2018-07-03 00:00:00','Vases','Very good price',15.51,'garden.jpg',12.50,'1',12,3);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-04 00:00:00','2018-07-02 00:00:00','Toy for boys','Very nice',20.59,'toy.jpg',25.13,'1',12,4);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-24 00:00:00','2018-07-02 00:00:00','Toy for little boys','Very cool',19.58,'toy2.jpeg',22.81,'1',12,2);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-14 00:00:00','2018-07-02 00:00:00','Kitchen design','Very cool',8.31,'garden2.jpeg',10.81,'1',12,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-01 00:00:00','2018-07-13 00:00:00','Water pump motors','The new one in the market!',60.00,'motor.jpg',100.07,'1',9,4);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-07 00:00:00','2018-07-16 00:00:00','Servo motors','Best worldwide servo motors',65.63,'motor2.jpg',120.53,'1',7,5);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-20 00:00:00','2018-07-03 00:00:00','Lit motors','New in the marker',35523.53,'motor3.jpg',55000.86,'1',17,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-06 00:00:00','2018-07-10 00:00:00','Baldor electric motors','Best conditions',32.62,'motor4.jpg',65.31,'1',13,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-08 00:00:00','2018-07-14 00:00:00','Mac Burguer','Delicious and tasty',3.47,'hamburguer.jpg',5.13,'1',13,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-01 00:00:00','2018-07-16 00:00:00','Best Perfume','The best perfume',80.58,'perfum.jpg',100.12,'1',18,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-06 00:00:00','2018-07-13 00:00:00','Bike 320','Fury Pro Mountain bike',260.57,'bike.jpeg',500.66,'1',8,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-14 00:00:00','2018-07-03 00:00:00','Raquet','The new one!',80.65,'tenis.jpg',100.30,'1',4,0);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-12 00:00:00','2018-07-12 00:00:00','Weights for the gym','Good conditions, with the best price.',15.69,'gym.jpeg',30.06,'1',6,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-10 00:00:00','2018-07-22 00:00:00','Books English collection','Really good',65.46,'book.jpg',80.53,'1',0,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-20 00:00:00','2018-07-03 00:00:00','Ipad Pro 12.9-inch','The new one in good conditions',600.61,'ipad.jpg',1000.23,'1',7,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-05 00:00:00','2018-07-04 00:00:00','Huawei 69GB','In good condition with one year warranty',260.53,'huawei.jpg',380.14,'1',15,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-24 00:00:00','2018-07-04 00:00:00','Macbook Pro - grey','It was only used 2 months, like new',1200.07,'mackbook2.jpg',2000.97,'1',6,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-03 00:00:00','2018-07-03 00:00:00','Bathroom furniture','In good condition, we ride in your house',1800.14,'bathroom.jpg',2300.42,'1',3,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-31 00:00:00','2018-07-03 00:00:00','Office','New office! Relaxed and clean environment',2100.10,'office.jpg',3100.67,'1',8,1);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-31 00:00:00','2018-07-05 00:00:00','Acer Swift 7','The new Acer from 2018!',450.10,'acerPc.jpg',560.67,'1',8,3);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-31 00:00:00','2018-07-03 00:00:00','Deel XPS 13','The new Dell with 13pl',450.10,'dellPc.png',560.67,'1',8,3);
INSERT INTO auction (dateBegin,dateEnd,name,description,actualPrice,auctionPhoto,buyNow,active,auction_like,auction_dislike) VALUES ('2018-03-31 00:00:00','2018-07-03 00:00:00','Perfum Dolce & Gabana','Dolce & Gabana light blue',15.10,'perfumDG.jpg',40.67,'1',12,1);


INSERT INTO bid (status,price,date,bid_id_auction,bid_id_user) VALUES ('0',0.80,DEFAULT,7,12);
INSERT INTO bid (status,price,date,bid_id_auction,bid_id_user) VALUES ('0',3.85,DEFAULT,16,26);
INSERT INTO bid (status,price,date,bid_id_auction,bid_id_user) VALUES ('0',1.59,DEFAULT,13,21);
INSERT INTO bid (status,price,date,bid_id_auction,bid_id_user) VALUES ('0',14.06,DEFAULT,30,24);
INSERT INTO bid (status,price,date,bid_id_auction,bid_id_user) VALUES ('0',5.86,DEFAULT,14,1);
INSERT INTO bid (status,price,date,bid_id_auction,bid_id_user) VALUES ('0',18.51,DEFAULT,8,17);

INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (4,3,'2018-05-26 00:46:15','Very good! I want to have them',19,1,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (14,3,'2018-05-28 02:28:40','Comes with a cover?',29,4,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (12,6,'2018-05-24 21:32:12','I need one of these for my garden',4,13,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (12,2,'2018-05-25 16:50:57','Very pretty!',4,30,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (10,4,'2018-04-01 16:57:16','I love photography! I really want to stay with this camera!',8,8,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (6,5,'2018-04-30 17:36:06','My children are so excited with this toy',14,14,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (6,5,'2018-05-01 04:19:56','The new one ? From David Bowie? Oh my god!!!',5,5,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (13,3,'2018-05-28 23:48:02','Very nicely decorated',13,16,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (10,6,'2018-05-22 16:56:52','How much time do they have?',16,20,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (6,4,'2018-05-21 19:48:28','Do you have a warranty?',16,3,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (11,2,'2018-05-22 00:39:35','Do you have more of these?',1,25,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (14,3,'2018-05-25 07:38:37','Are they new?',6,11,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (11,2,'2018-05-24 12:15:12','Do you have a guarantee?',7,21,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (11,4,'2018-05-29 08:03:59','What an unbelievable price! Are you silly?',14,30,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (11,4,'2018-05-21 08:03:59','Do you think it is expensive? Try to get cheaper in the market',13,30,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (9,4,'2018-05-11 13:18:39','Very nice!',29,17,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (8,2,'2018-05-22 16:46:37','Are they new?',4,19,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (11,1,'2018-05-01 05:41:24','Do you have a warranty?',1,29,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (13,5,'2018-05-23 17:05:54','How long was it used?',20,28,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (2,3,'2018-05-23 14:41:11','The level of English is for what age?',28,26,'1');
INSERT INTO comment ("like",dislike,"date",comment,id_user,id_auction,available) VALUES (11,4,'2018-05-21 08:03:59','This product is not good',1,21,'1');

INSERT INTO reportUser (reason,id_userReporting,id_userReported,date) VALUES ('Said incorrectly',11,14,'2018-05-29 01:46:15');
INSERT INTO reportUser (reason,id_userReporting,id_userReported,date) VALUES ('Aggressive and arrogant in the comments',9,14,'2018-05-29 00:46:15');
INSERT INTO reportUser (reason,id_userReporting,id_userReported,date) VALUES ('Inappropriate content in the comment',7,5,'2018-05-22 00:46:15');
INSERT INTO reportUser (reason,id_userReporting,id_userReported,date) VALUES ('Aggressive with other people opinions',10,13,'2018-05-21 00:46:15');
INSERT INTO reportUser (reason,id_userReporting,id_userReported,date) VALUES ('Speak badly about the product',5,1,'2018-05-22 00:46:15');
INSERT INTO reportUser (reason,id_userReporting,id_userReported,date) VALUES ('Aggressive and intolerant',10,1,'2018-05-30 00:46:15');
INSERT INTO reportUser (reason,id_userReporting,id_userReported,date) VALUES ('Inappropriate comments',20,13,'2018-05-26 00:46:15');
INSERT INTO reportUser (reason,id_userReporting,id_userReported,date) VALUES ('Insulting remarks',24,17,'2018-05-26 00:46:15');
INSERT INTO reportUser (reason,id_userReporting,id_userReported,date) VALUES ('Makes unnecessary comments',8,6,'2018-05-26 00:46:15');

INSERT INTO reportAuction (id_user,id_auction,reason,date) VALUES (2,26,'Inappropiate content','2018-04-20 00:46:15');
INSERT INTO reportAuction (id_user,id_auction,reason,date) VALUES (12,23,'Abusive price','2018-03-20 00:46:15');

INSERT INTO owner (id_user,id_auction) VALUES (1,1);
INSERT INTO owner (id_user,id_auction) VALUES (17,2);
INSERT INTO owner (id_user,id_auction) VALUES (10,3);
INSERT INTO owner (id_user,id_auction) VALUES (20,4);
INSERT INTO owner (id_user,id_auction) VALUES (14,5);
INSERT INTO owner (id_user,id_auction) VALUES (8,6);
INSERT INTO owner (id_user,id_auction) VALUES (22,7);
INSERT INTO owner (id_user,id_auction) VALUES (3,8);
INSERT INTO owner (id_user,id_auction) VALUES (1,9);
INSERT INTO owner (id_user,id_auction) VALUES (6,10);
INSERT INTO owner (id_user,id_auction) VALUES (24,11);
INSERT INTO owner (id_user,id_auction) VALUES (16,12);
INSERT INTO owner (id_user,id_auction) VALUES (17,13);
INSERT INTO owner (id_user,id_auction) VALUES (14,14);
INSERT INTO owner (id_user,id_auction) VALUES (4,15);
INSERT INTO owner (id_user,id_auction) VALUES (15,16);
INSERT INTO owner (id_user,id_auction) VALUES (5,17);
INSERT INTO owner (id_user,id_auction) VALUES (21,18);
INSERT INTO owner (id_user,id_auction) VALUES (16,19);
INSERT INTO owner (id_user,id_auction) VALUES (24,20);
INSERT INTO owner (id_user,id_auction) VALUES (28,21);
INSERT INTO owner (id_user,id_auction) VALUES (22,22);
INSERT INTO owner (id_user,id_auction) VALUES (30,23);
INSERT INTO owner (id_user,id_auction) VALUES (6,24);
INSERT INTO owner (id_user,id_auction) VALUES (29,25);
INSERT INTO owner (id_user,id_auction) VALUES (13,26);
INSERT INTO owner (id_user,id_auction) VALUES (18,27);
INSERT INTO owner (id_user,id_auction) VALUES (28,28);
INSERT INTO owner (id_user,id_auction) VALUES (25,29);
INSERT INTO owner (id_user,id_auction) VALUES (27,30);
INSERT INTO owner (id_user,id_auction) VALUES (15,31);
INSERT INTO owner (id_user,id_auction) VALUES (28,32);
INSERT INTO owner (id_user,id_auction) VALUES (1,33);
INSERT INTO owner (id_user,id_auction) VALUES (7,34);


INSERT INTO banUser (id_user,id_admin,date) VALUES (13,30,'2018-05-19 01:43:11');
INSERT INTO banUser (id_user,id_admin,date) VALUES (5,31,'2018-05-13 11:43:42');
INSERT INTO banUser (id_user,id_admin,date) VALUES (14,32,'2018-05-14 07:45:18');
INSERT INTO banUser (id_user,id_admin,date) VALUES (1,30,'2018-05-13 14:19:08');


INSERT INTO banAuction (id_user,id_auction,date) VALUES (2,26,'2018-04-07 12:30:37');
INSERT INTO banAuction (id_user,id_auction,date) VALUES (12,24,'2018-04-07 23:54:50');
INSERT INTO banAuction (id_user,id_auction,date) VALUES (13,17,'2018-04-08 17:25:38');
INSERT INTO banAuction (id_user,id_auction,date) VALUES (26,29,'2018-04-08 06:36:13');
INSERT INTO banAuction (id_user,id_auction,date) VALUES (5,13,'2018-04-05 11:43:16');
INSERT INTO banAuction (id_user,id_auction,date) VALUES (30,27,'2018-04-09 10:33:17');
INSERT INTO banAuction (id_user,id_auction,date) VALUES (11,2,'2018-04-05 22:49:11');

INSERT INTO wishList (user_id,auction_id,date) VALUES (1,14,'2018-04-03 23:43:54');
INSERT INTO wishList (user_id,auction_id,date) VALUES (2,18,'2018-04-02 16:41:23');
INSERT INTO wishList (user_id,auction_id,date) VALUES (34,20,'2018-04-02 11:22:29');
INSERT INTO wishList (user_id,auction_id,date) VALUES (34,15,'2018-04-02 17:35:58');
INSERT INTO wishList (user_id,auction_id,date) VALUES (13,1,'2018-04-01 10:49:53');
INSERT INTO wishList (user_id,auction_id,date) VALUES (8,9,'2018-04-01 11:17:49');

INSERT INTO category (id_auction,Category) VALUES (1,'Electronics');
INSERT INTO category (id_auction,Category) VALUES (2,'Electronics');
INSERT INTO category (id_auction,Category) VALUES (3,'Electronics');
INSERT INTO category (id_auction,Category) VALUES (4,'Electronics');
INSERT INTO category (id_auction,Category) VALUES (5,'Music');
INSERT INTO category (id_auction,Category) VALUES (6,'Music');
INSERT INTO category (id_auction,Category) VALUES (7,'Music');
INSERT INTO category (id_auction,Category) VALUES (8,'Electronics');
INSERT INTO category (id_auction,Category) VALUES (9,'Electronics');
INSERT INTO category (id_auction,Category) VALUES (10,'Fashion');
INSERT INTO category (id_auction,Category) VALUES (11,'Fashion');
INSERT INTO category (id_auction,Category) VALUES (12,'Fashion');
INSERT INTO category (id_auction,Category) VALUES (13,'Home & Garden');
INSERT INTO category (id_auction,Category) VALUES (14,'Toys');
INSERT INTO category (id_auction,Category) VALUES (15,'Toys');
INSERT INTO category (id_auction,Category) VALUES (16,'Home & Garden');
INSERT INTO category (id_auction,Category) VALUES (17,'Motors');
INSERT INTO category (id_auction,Category) VALUES (18,'Motors');
INSERT INTO category (id_auction,Category) VALUES (19,'Motors');
INSERT INTO category (id_auction,Category) VALUES (20,'Motors');
INSERT INTO category (id_auction,Category) VALUES (21,'Daily Deals');
INSERT INTO category (id_auction,Category) VALUES (22,'Daily Deals');
INSERT INTO category (id_auction,Category) VALUES (23,'Sporting');
INSERT INTO category (id_auction,Category) VALUES (24,'Sporting');
INSERT INTO category (id_auction,Category) VALUES (25,'Sporting');
INSERT INTO category (id_auction,Category) VALUES (26,'Others');
INSERT INTO category (id_auction,Category) VALUES (27,'Electronics');
INSERT INTO category (id_auction,Category) VALUES (28,'Electronics');
INSERT INTO category (id_auction,Category) VALUES (29,'Electronics');
INSERT INTO category (id_auction,Category) VALUES (30,'Home & Garden');
INSERT INTO category (id_auction,Category) VALUES (31,'Home & Garden');
INSERT INTO category (id_auction,Category) VALUES (32,'Electronics');
INSERT INTO category (id_auction,Category) VALUES (33,'Electronics');
INSERT INTO category (id_auction,Category) VALUES (34,'Daily Deals');


INSERT INTO buyNow (id_user,id_auction) VALUES (17,26);
INSERT INTO buyNow (id_user,id_auction) VALUES (2,30);
INSERT INTO buyNow (id_user,id_auction) VALUES (30,13);
INSERT INTO buyNow (id_user,id_auction) VALUES (1,31);
INSERT INTO buyNow (id_user,id_auction) VALUES (12,16);


INSERT INTO endAuction (id_user,id_auction,status) VALUES (17,26,'1');
INSERT INTO endAuction (id_user,id_auction,status) VALUES (2,30,'0');
INSERT INTO endAuction (id_user,id_auction,status) VALUES (1,31,'0');
