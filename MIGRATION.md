# Migration steps

* Step 1: Modify DNS
  (point to application)
* Step 2: Make DB dump
* Step 3: Import DB dump
  `cat  vlaamswoordenboek.mysqldumpprepare vlaamswoordenboek.mysqldump | mysql -u web -p -h staging-do-user-9650701-0.b.db.ondigitalocean.com -P 25060 -D vlaamswoordenboek`
  This took 10 minutes from home (speed might depend on internet)
* Step 4: Fix databse/UTF8
  ~~~
  ALTER TABLE definitions MODIFY COLUMN description BLOB;
  ALTER TABLE definitions MODIFY COLUMN example BLOB;
  ALTER TABLE definitions MODIFY COLUMN word BLOB;

  ALTER TABLE definition_versions MODIFY COLUMN description BLOB;
  ALTER TABLE definition_versions MODIFY COLUMN example BLOB;
  ALTER TABLE definition_versions MODIFY COLUMN word BLOB;

  ALTER TABLE reactions MODIFY COLUMN body BLOB;
  ALTER TABLE reactions MODIFY COLUMN title BLOB;

  ALTER TABLE messages MODIFY COLUMN body BLOB;
  ALTER TABLE messages MODIFY COLUMN title BLOB;



  ALTER TABLE definitions MODIFY COLUMN description text CHARACTER SET UTF8MB4;
  ALTER TABLE definitions MODIFY COLUMN example text CHARACTER SET UTF8MB4;
  ALTER TABLE definitions MODIFY COLUMN word varchar(255) CHARACTER SET UTF8MB4;

  ALTER TABLE definition_versions MODIFY COLUMN description text CHARACTER SET UTF8MB4;
  ALTER TABLE definition_versions MODIFY COLUMN example text CHARACTER SET UTF8MB4;
  ALTER TABLE definitions MODIFY COLUMN word varchar(255) CHARACTER SET UTF8MB4;

  ALTER TABLE reactions MODIFY COLUMN body text CHARACTER SET UTF8MB4;
  ALTER TABLE reactions MODIFY COLUMN title varchar(255) CHARACTER SET UTF8MB4;

  ALTER TABLE messages MODIFY COLUMN body text CHARACTER SET UTF8MB4;
  ALTER TABLE messages MODIFY COLUMN title varchar(255) CHARACTER SET UTF8MB4;
  ~~~


# Application setup
* Create Database cluster
* Add new user (call it web)
* Create new application
* mysql2://${staging.USERNAME}:${staging.PASSWORD}@${staging.HOSTNAME}:${staging.PORT}/${staging.DATABASE}



# Reset Database
DROP TABLE globalize_countries;
DROP TABLE messages;
DROP TABLE reactions;
DROP TABLE globalize_translations;
DROP TABLE globalize_languages;
DROP TABLE comments;
DROP TABLE definitions;
DROP TABLE definition_versions;
DROP TABLE forums;
DROP TABLE forumtopics;
