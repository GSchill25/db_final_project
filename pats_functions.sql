-- FUNCTIONS AND TRIGGERS FOR PATS DATABASE
--
-- by (student_1) & (student_2)
--
--
-- calculate_total_costs
-- (associated with two triggers: update_total_costs_for_medicines_changes & update_total_costs_for_treatments_changes)
CREATE OR REPLACE FUNCTION update_total_costs_for_medicines_changes() RETURNS TRIGGER AS $$
	DECLARE
		last_visit INTEGER;
		units_given INTEGER;
		discount REAL;
		cost_per_unit INTEGER;
		medicine_cost REAL;
		r visit_medicines%rowtype;
	BEGIN
		last_visit = (SELECT last_value FROM visits_id_seq);
		FOR r in SELECT * FROM visit_medicines WHERE visit_medicines.id=last_visit LOOP
			units_given = (SELECT units_given FROM r);
			RAISE NOTICE '%',units_given;
			discount = (SELECT discount FROM r);
			RAISE NOTICE '%',discount;
			cost_per_unit = (SELECT cost_per_unit FROM medicine_costs mc WHERE r.medicine_id=mc.medicine_id);
			RAISE NOTICE '%',cost_per_unit;
			medicine_cost = cost_per_unit * units_given * (1-discount);
			RAISE NOTICE '%',medicine_cost;
			UPDATE visits SET total_charge = (total_charge + medicine_cost) WHERE visits.id=last_visit;
		
		END LOOP;
	  RETURN NULL;

	END;
	$$ LANGUAGE plpgsql;


CREATE FUNCTION update_total_costs_for_treatments_changes() RETURNS TRIGGER AS $$
	DECLARE
		last_visit INTEGER;
		procedure_cost INTEGER;
		discount REAL;
		procedure_total REAL;
	BEGIN
		last_visit = (SELECT currval(pg_get_serial_sequence('visits', 'id')));
		discount = SELECT discount FROM treaments t WHERE t.visit_id=last_visit; 
		procedure_cost = SELECT pc.cost FROM procedure_costs pc JOIN procedures p ON pc.procedure_id=p.id
		JOIN treaments t ON p.id=t.procedure_id WHERE t.visit_id=last_visit AND pc.end_date IS NULL;
		procedure_total = procedure_cost * (1-discount);
		UPDATE visits SET total_charge = (total_charge + procedure_total) WHERE visits.id=last_visit;
	  RETURN NULL;

	END;
	$$ LANGUAGE plpgsql;


CREATE TRIGGER calculate_total_costs
AFTER UPDATE OR INSERT ON visits
EXECUTE PROCEDURE update_total_costs_for_medicines_changes();



-- calculate_overnight_stay
-- (associated with a trigger: update_overnight_stay_flag)
CREATE OR REPLACE FUNCTION calculate_overnight_stay() RETURNS TRIGGER AS $$
	DECLARE
		last_visit INTEGER;
		length_of_time INTEGER;
	BEGIN
		last_visit = OLD.id;
		length_of_time = (SELECT SUM(p.length_of_time) FROM procedures p JOIN treatments t ON p.id=t.procedure_id WHERE t.visit_id=last_visit);
		IF (length_of_time) >= 720 THEN 
			UPDATE visits SET overnight_stay = true WHERE id=last_visit;
		END IF;
	 RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;

CREATE TRIGGER update_overnight_stay_flag
AFTER UPDATE ON visits
FOR EACH ROW
WHEN (OLD IS DISTINCT FROM NEW)
EXECUTE PROCEDURE calculate_overnight_stay();


-- set_end_date_for_medicine_costs
-- (associated with a trigger: set_end_date_for_previous_medicine_cost)




-- set_end_date_for_procedure_costs
-- (associated with a trigger: set_end_date_for_previous_procedure_cost)




-- decrease_stock_amount_after_dosage
-- (associated with a trigger: update_stock_amount_for_medicines)
CREATE OR REPLACE FUNCTION decrease_stock_amount_after_dosage() RETURNS TRIGGER AS $$
	DECLARE
		units_given INTEGER;
		new_visit_med_id INTEGER;
		med INTEGER;

	BEGIN
		new_visit_med_id = (SELECT currval(pg_get_serial_sequence('visit_medicines', 'id')));
		units_given = (SELECT vm.units_given FROM visit_medicines vm WHERE id=new_visit_med_id);
		med = (SELECT medicine_id FROM visit_medicines WHERE id = new_visit_med_id);
		UPDATE medicines SET stock_amount = (stock_amount-units_given) WHERE id=med;
	  RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;


CREATE TRIGGER update_stock_amount_for_medicines
AFTER INSERT ON visit_medicines
EXECUTE PROCEDURE decrease_stock_amount_after_dosage();





-- verify_that_medicine_requested_in_stock
-- (takes medicine_id and units_needed as arguments and returns a boolean)




-- verify_that_medicine_is_appropriate_for_pet
-- (takes medicine_id and pet_id as arguments and returns a boolean)

