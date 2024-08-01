SET ECHO ON

rem : Dropping all tables

DROP TABLE reviews;
DROP TABLE reviews_link;
DROP TABLE references;
DROP TABLE submissions;
DROP TABLE presentations;
DROP TABLE article_authors;
DROP TABLE articles;
DROP TABLE topics;
DROP TABLE topic_domains;
DROP TABLE conference_attendees;
DROP TABLE conference_lecturers;
DROP TABLE conferences;
DROP TABLE published_journals;
DROP TABLE journals;
DROP TABLE publishers;
DROP TABLE users;
DROP TABLE cities;
DROP TABLE states;
DROP TABLE organization;

rem : Creating all tables

CREATE TABLE organization(
    organization_id VARCHAR(10),
    organization_name VARCHAR(100),
    organization_type VARCHAR(100),
    CONSTRAINT org_pk PRIMARY KEY(organization_id),
    CONSTRAINT org_id_chk CHECK (organization_id LIKE 'O%')
);

INSERT INTO organization VALUES('O001', 'LT Ltd.', 'Multinational Company');
INSERT INTO organization VALUES('O002', 'Club Mahindra', 'Hospitality');


DESC organization;

CREATE TABLE states(
    state_id VARCHAR(10),
    state_name VARCHAR(50),
    CONSTRAINT state_pk PRIMARY KEY(state_id),
    CONSTRAINT state_id_chk CHECK(state_id LIKE 'S%')
);

INSERT INTO states VALUES('S001', 'Tamil Nadu');
INSERT INTO states VALUES('S002', 'Karnataka');

DESC states;

DROP TABLE cities;

CREATE TABLE cities(
    state_id VARCHAR(10),
    city_id VARCHAR(10),
    city_name VARCHAR(30),
    CONSTRAINT city_pk PRIMARY KEY(city_id),
    CONSTRAINT city_fk FOREIGN KEY(state_id) REFERENCES states,
    CONSTRAINT city_id_chk CHECK(city_id LIKE 'Ci%')
);

INSERT INTO cities VALUES('S001', 'Ci001', 'Chennai');
INSERT INTO cities VALUES('S001', 'Ci002', 'Kanchipuram');
INSERT INTO cities VALUES('S002', 'Ci003', 'Bangalore');

DESC cities;

CREATE TABLE users(
    user_id VARCHAR(10),
    user_name VARCHAR(20),
    password VARCHAR(20),
    email VARCHAR(45),
    user_type VARCHAR(15),
    organization_id VARCHAR(10),
    city_id VARCHAR(10),
    CONSTRAINT users_pk PRIMARY KEY(user_id),
    CONSTRAINT users_fk_1 FOREIGN KEY(organization_id) REFERENCES organization,
    CONSTRAINT users_fk_2 FOREIGN KEY(city_id) REFERENCES cities,
    CONSTRAINT user_id_chk CHECK(user_id LIKE 'U%'),
    CONSTRAINT email_chk CHECK(email LIKE '%@gmail.com'),
    CONSTRAINT user_type_chk CHECK (user_type IN('Student', 'Author', 'Lecturer'))
);

DESC users;

CREATE TABLE publishers(
    publisher_id VARCHAR(10),
    publisher_name VARCHAR(20),
    CONSTRAINT pub_pk PRIMARY KEY(publisher_id),
    CONSTRAINT pub_id_chk CHECK (publisher_id LIKE 'P%')
);

INSERT INTO publishers VALUES('P001', 'Sathya Publications');
INSERT INTO publishers VALUES('P002', 'Aruna Publications');

DESC publishers;

CREATE TABLE journals(
    ISSN VARCHAR(20),
    journal_name VARCHAR(30),
    publisher_id VARCHAR(10),
    date_of_publishing date,
    CONSTRAINT journal_pk PRIMARY KEY(ISSN),
    CONSTRAINT journal_fk FOREIGN KEY(publisher_id) REFERENCES publishers,
    CONSTRAINT iss_chk CHECK (issn LIKE 'J%')
);

INSERT INTO journals VALUES('J001', 'AI/ML Research Papers', 'P001', '26-MAY-2024');
INSERT INTO journals VALUES('J002', 'Career development', 'P001', '26-MAY-2024');
INSERT INTO journals VALUES('J003', 'Fiction', 'P002', '26-MAY-2024');
INSERT INTO journals VALUES('J004', 'General', 'P001', '26-MAY-2024');
INSERT INTO journals VALUES('J005', 'IAS/IPS', 'P002', '26-MAY-2024');

DESC journals;

CREATE TABLE published_journals(
    publisher_id VARCHAR(10),
    ISSN VARCHAR(20),
    CONSTRAINT p_journals_fk PRIMARY KEY(publisher_id, ISSN),
    CONSTRAINT p_journal_fk FOREIGN KEY(publisher_id) REFERENCES publishers
);

DESC published_journals;

CREATE TABLE conferences(
    conference_id VARCHAR(10),
    conference_title VARCHAR(100),
    city_id VARCHAR(10),
    organization_id VARCHAR(10),
    start_date date,
    end_date date,
    CONSTRAINT conferences_pk PRIMARY KEY(conference_id),
    CONSTRAINT conferences_fk1 FOREIGN KEY(organization_id) REFERENCES organization,
    CONSTRAINT conferences_fk2 FOREIGN KEY(city_id) REFERENCES cities,
    CONSTRAINT conf_id_chk CHECK(conference_id LIKE 'C%'),
    CONSTRAINT dates_chk CHECK(end_date >= start_date)
);

INSERT INTO conferences VALUES('C001', 'Automation in cars', 'Ci003', 'O001', '12-JUN-2024', '13-JUN-2024');
INSERT INTO conferences VALUES('C002', 'Windmills and their working', 'Ci001', 'O001', '12-MAY-2024', '12-MAY-2024');
INSERT INTO conferences VALUES('C003', 'Need for hospitality', 'Ci002', 'O002', '16-SEP-2024', '23-SEP-2024');
INSERT INTO conferences VALUES('C004', 'Basement of Hotel Management', 'Ci001', 'O002', '12-JUN-2024', '13-JUN-2024');
INSERT INTO conferences VALUES('C005', 'How to crack interviews', 'Ci002', 'O001', '09-JAN-2024', '11-JAN-2024');

DESC conferences;

CREATE TABLE conference_lecturers(
    conference_id VARCHAR(10),
    lecturer_id VARCHAR(20),
    CONSTRAINT c_lec_pk PRIMARY KEY(conference_id, lecturer_id),
    CONSTRAINT c_lec_fk1 FOREIGN KEY(conference_id) REFERENCES conferences,
    CONSTRAINT c_lec_fk2 FOREIGN KEY(lecturer_id) REFERENCES users
);

DESC conference_lecturers;

CREATE TABLE conference_attendees(
    conference_id VARCHAR(10),
    attendee_id VARCHAR(20),
    CONSTRAINT c_att_pk PRIMARY KEY(conference_id, attendee_id),
    CONSTRAINT c_att_fk1 FOREIGN KEY(conference_id) REFERENCES conferences,
    CONSTRAINT c_att_fk2 FOREIGN KEY(attendee_id) REFERENCES users
);

DESC conference_attendees;

CREATE TABLE topic_domains(
    topic_name VARCHAR(40),
    topic_domain VARCHAR(40),
    CONSTRAINT td_pk PRIMARY KEY(topic_name)
);

DESC topic_domains;

CREATE TABLE topics(
    topic_id VARCHAR(10),
    topic_name VARCHAR(40),
    CONSTRAINT topics_pk PRIMARY KEY(topic_id),
    CONSTRAINT topics_fk FOREIGN KEY(topic_name) REFERENCES topic_domains,
    CONSTRAINT topic_id_chk CHECK(topic_id LIKE 'T%')
);

DESC topics;

CREATE TABLE articles(
    article_id VARCHAR(10),
    ISSN VARCHAR(10),
    article_name VARCHAR(100),
    topic_name VARCHAR(40),
    DOI date,
    article_link VARCHAR(100),
    CONSTRAINT articles_pk PRIMARY KEY(article_id),
    CONSTRAINT articles_fk1 FOREIGN KEY(ISSN) REFERENCES journals,
    CONSTRAINT articles_fk2 FOREIGN KEY(topic_name) REFERENCES topics,
    CONSTRAINT article_id_chk CHECK(article_id LIKE 'A%'),
    CONSTRAINT article_link_chk CHECK(article_link LIKE 'https%')
);

DESC articles;

CREATE TABLE article_authors(
    article_id VARCHAR(10),
    author_id VARCHAR(10),
    CONSTRAINT a_aut_pk PRIMARY KEY(article_id, author_id),
    CONSTRAINT a_aut_fk1 FOREIGN KEY(article_id) REFERENCES articles,
    CONSTRAINT a_aut_fk2 FOREIGN KEY(author_id) REFERENCES users
);

DESC article_authors;

CREATE TABLE submissions(
    submission_id VARCHAR(10),
    ISSN VARCHAR(10),
    article_id VARCHAR(10),
    CONSTRAINT sub_pk PRIMARY KEY(submission_id),
    CONSTRAINT sub_fk1 FOREIGN KEY(ISSN) REFERENCES journals,
    CONSTRAINT sub_fk2 FOREIGN KEY(article_id) REFERENCES articles,
    CONSTRAINT sub_id_chk CHECK(submission_id LIKE 's%')
);

DESC submissions;

CREATE TABLE presentations(
    presentation_id VARCHAR(10),
    article_id VARCHAR(10),
    conference_id VARCHAR(10),
    CONSTRAINT pres_pk PRIMARY KEY(presentation_id),
    CONSTRAINT pres_fk1 FOREIGN KEY(article_id) REFERENCES articles,
    CONSTRAINT pres_fl2 FOREIGN KEY(conference_id) REFERENCES conferences,
    CONSTRAINT pres_id_chk CHECK(presentation_id LIKE 's%')
);
DESC presentations;

CREATE TABLE references(
    article_id VARCHAR(10),
    referenced_id VARCHAR(10),
    CONSTRAINT ref_pk PRIMARY KEY(article_id, referenced_id),
    CONSTRAINT ref_fk1 FOREIGN KEY(referenced_id) references articles,
    CONSTRAINT ref_fk2 FOREIGN KEY(article_id) references articles,
    CONSTRAINT articles_chk CHECK(article_id != referenced_id)
);

DESC references;

CREATE TABLE reviews_link(
    review_link VARCHAR(100),
    rating NUMBER(2,1),
    CONSTRAINT r_link_pk PRIMARY KEY(review_link),
    CONSTRAINT r_link_chk CHECK(review_link LIKE 'https%'),
    CONSTRAINT rating_chk CHECK(rating >= 1 AND rating <= 10)
);

DESC reviews_link;

CREATE TABLE reviews(
    reviewer_id VARCHAR(10),
    article_id VARCHAR(10),
    review_link VARCHAR(100),
    CONSTRAINT r_pk PRIMARY KEY(reviewer_id),
    CONSTRAINT r_fk1 FOREIGN KEY(review_link) REFERENCES reviews_link,
    CONSTRAINT r_fk2 FOREIGN KEY(article_id) REFERENCES articles
);

DESC reviews;

SELECT * FROM conferences;
SELECT * FROM cities;
SELECT * FROM states;

DROP TABLE reviews;
DROP TABLE reviews_link;
DROP TABLE references;
DROP TABLE submissions;
DROP TABLE presentations;
DROP TABLE article_authors;
DROP TABLE articles;
DROP TABLE topics;
DROP TABLE topic_domains;
DROP TABLE conference_attendees;
DROP TABLE conference_lecturers;
DROP TABLE conferences;
DROP TABLE published_journals;
DROP TABLE journals;
DROP TABLE publishers;
DROP TABLE users;
DROP TABLE cities;
DROP TABLE states;
DROP TABLE organization;