-- Deploy scrapetition-sql:url_scraped_insert_trigger to sqlite
-- requires: url
-- requires: url_scraped

BEGIN;

-- First make sure, that the urls are the url table 	 
CREATE OR REPLACE FUNCTION url_source_insert()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO url (url) VALUES (NEW.source_url) ON CONFLICT DO NOTHING;
    INSERT INTO url (url) VALUES (NEW.target_url) ON CONFLICT DO NOTHING;
    -- Then add the pair to the url_scraped table
    INSERT INTO url_scraped (source, target) VALUES
    	   ((SELECT url_id FROM url WHERE url = NEW.source_url)
    	   ,(SELECT url_id FROM url WHERE url = NEW.target_url)) ON CONFLICT DO NOTHING;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;


CREATE TRIGGER url_source_insert INSTEAD OF INSERT ON url_source
FOR EACH ROW EXECUTE PROCEDURE url_source_insert();

COMMIT;
