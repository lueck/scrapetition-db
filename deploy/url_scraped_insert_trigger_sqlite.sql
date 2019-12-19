-- Deploy scrapetition-sql:url_scraped_insert_trigger to sqlite
-- requires: url
-- requires: url_scraped

BEGIN;

CREATE TRIGGER url_source_insert
INSTEAD OF INSERT ON url_source
FOR EACH ROW BEGIN
    -- First make sure, that the urls are the url table 	 
    INSERT OR IGNORE INTO url (url) VALUES (NEW.source);
    INSERT OR IGNORE INTO url (url) VALUES (NEW.target);
    UPDATE url SET last_seen = CURRENT_TIMESTAMP WHERE url_id = NEW.source;
    -- Then add the pair to the url_scraped table
    INSERT OR IGNORE INTO url_scraped (source, target) VALUES
    	   ((SELECT url_id FROM url WHERE url = NEW.source)
	   ,(SELECT url_id FROM url WHERE url = NEW.target));
END;

COMMIT;
