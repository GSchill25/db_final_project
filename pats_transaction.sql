-- TRANSACTION EXAMPLE FOR PATS DATABASE
--
-- by Alex Mark & Graham Schilling
--
--

BEGIN;
INSERT INTO visits (pet_id, date, weight) VALUES (173, current_date, 39);
INSERT INTO treatments (visit_id, procedure_id) VALUES ((SELECT currval('visits_id_seq')), 2);
SELECT verify_that_medicine_requested_in_stock(3, 500);
SELECT verify_that_medicine_is_appropriate_for_pet(3, 173);
INSERT INTO visit_medicines (visit_id, medicine_id, units_given) VALUES ((SELECT currval('visits_id_seq')), 3, 500);
SELECT verify_that_medicine_requested_in_stock(5, 200);
SELECT verify_that_medicine_is_appropriate_for_pet(5, 173);
INSERT INTO visit_medicines (visit_id, medicine_id, units_given) VALUES ((SELECT currval('visits_id_seq')), 5, 200);
COMMIT;