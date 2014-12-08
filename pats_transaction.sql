-- TRANSACTION EXAMPLE FOR PATS DATABASE
--
-- by Alex Mark & Graham Schilling
--
--

BEGIN;
INSERT INTO visits (pet_id, date, weight) VALUES (173, current_date, 39);
INSERT INTO treatments (visit_id, procedure_id, successful) VALUES (, 2, );
COMMIT;