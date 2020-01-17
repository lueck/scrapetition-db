-- Deploy scrapetition-sql:comments_insert_trigger to pg
-- requires: url
-- requires: comments

-- Create a trigger for inserting into the comments view.

BEGIN;

CREATE OR REPLACE FUNCTION scrapetition.comments_insert()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO scrapetition.url (url)
    	   VALUES (NEW.url) ON CONFLICT DO NOTHING;
    INSERT INTO scrapetition."user" ("user", name)
    	   VALUES (NEW.user, name) ON CONFLICT DO NOTHING;
    INSERT INTO scrapetition.comment
    (id, domain, text, title, user_id, name, date_informal, date,
    parent, thread, up_votes, down_votes, url_id, scraper)
    VALUES
    (NEW.id, NEW.domain, NEW.text, NEW.title,
    (SELECT user_id FROM scrapetition."user" WHERE "user" = NEW.user),
    NEW.name,
    NEW.date_informal, NEW.date, NEW.parent, NEW.thread, NEW.up_votes,
    NEW.down_votes,
    (SELECT url_id FROM scrapetition.url WHERE url = NEW.url),
    NEW.scraper)
    ON CONFLICT DO NOTHING;
    -- DO UPDATE SET (last_scraped, text) = (CURRENT_TIMESTAMP, NEW.text)
    -- WHERE id = NEW.id AND domain = NEW.domain;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER comments_insert INSTEAD OF INSERT ON scrapetition.comments
FOR EACH ROW EXECUTE PROCEDURE scrapetition.comments_insert();

COMMIT;
