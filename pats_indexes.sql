-- INDEXES FOR PATS DATABASE
--
-- by Graham Schilling & Alex Mark
--
--

CREATE INDEX medicines_index ON medicines USING gin(to_tsvector('description', body));

CREATE INDEX pet_index ON pets(name);

CREATE INDEX visit_index ON visits(total_charge);

CREATE INDEX med_index ON medicines(name);

CREATE INDEX procedure_index ON procedures(name);