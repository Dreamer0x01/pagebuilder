CREATE TABLE IF NOT EXISTS `{PREFIX}pagebuilder` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int(10) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `config` varchar(255) NOT NULL,
  `values` mediumtext NOT NULL,
  `index` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`)
);


# Upgrading to v1.1.0

# adding column for sections container

ALTER TABLE {PREFIX}pagebuilder ADD COLUMN container varchar(255) DEFAULT NULL AFTER document_id;

ALTER TABLE {PREFIX}pagebuilder DROP INDEX `document_id`;

ALTER TABLE {PREFIX}pagebuilder ADD INDEX `document_id` (`document_id`, `container`);

# Adding visibility option

ALTER TABLE {PREFIX}pagebuilder ADD COLUMN visible tinyint(1) unsigned DEFAULT 1 AFTER `values`;

# Fix #51

UPDATE {PREFIX}pagebuilder SET `container` = 'default' WHERE `container` IS NULL;

UPDATE {PREFIX}pagebuilder SET `config` = REPLACE(`config`, '.php', '') WHERE `config` REGEXP '\.php$';

# Fix, default value for title

ALTER TABLE {PREFIX}pagebuilder CHANGE `title` `title` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;

# Subcontainers

ALTER TABLE {PREFIX}pagebuilder DROP `title`;

ALTER TABLE {PREFIX}pagebuilder ADD COLUMN `parent_id` INT(10) UNSIGNED NOT NULL DEFAULT '0' AFTER `container`;

ALTER TABLE {PREFIX}pagebuilder ADD COLUMN `subcontainer` VARCHAR(255) NOT NULL DEFAULT '' AFTER `parent_id`;

ALTER TABLE {PREFIX}pagebuilder ADD COLUMN `hash` VARCHAR(255) NOT NULL DEFAULT '' AFTER `subcontainer`;
