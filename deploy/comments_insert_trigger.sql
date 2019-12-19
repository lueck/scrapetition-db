-- Deploy scrapetition-sql:comments_insert_trigger to pg
-- requires: url
-- requires: comments

-- Create a trigger for inserting into the comments view.

BEGIN;

CREATE OR REPLACE FUNCTION comments_insert()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO url (url) VALUES (NEW.url) ON CONFLICT DO NOTHING;
    INSERT INTO comment
    (id, domain, text, title, "user", name, date_informal, date,
    parent, thread, up_votes, down_votes, url_id, scraper)
    VALUES
    (NEW.id, NEW.domain, NEW.text, NEW.title, NEW."user", NEW.name,
    NEW.date_informal, NEW.date, NEW.parent, NEW.thread, NEW.up_votes,
    NEW.down_votes,
    (SELECT url_id FROM url WHERE url = NEW.url),
    NEW.scraper)
    ON CONFLICT DO NOTHING;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER comments_insert INSTEAD OF INSERT ON comments
FOR EACH ROW EXECUTE PROCEDURE comments_insert();

COMMIT;