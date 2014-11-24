-- INDEXES FOR PATS DATABASE
--
-- by Graham Schilling & Alex Mark
--
--

CREATE INDEX medicines_index ON medicines USING gin(to_tsvector('description', body));