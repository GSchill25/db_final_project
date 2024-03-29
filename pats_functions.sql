-- FUNCTIONS AND TRIGGERS FOR PATS DATABASE
--
-- by Alex Mark & Graham Schilling
--
--
-- calculate_total_costs
-- (associated with two triggers: update_total_costs_for_medicines_changes & update_total_costs_for_treatments_changes)

CREATE OR REPLACE FUNCTION calculate_total_costs() RETURNS TRIGGER AS $$
	DECLARE
		last_visit INTEGER;
        amount_treatments INTEGER;
        amount_medicines INTEGER;
        total_amount INTEGER;
	BEGIN
		last_visit = NEW.visit_id;

        amount_treatments = (SELECT ROUND(SUM(pc.cost * (1-t.discount))) FROM treatments t JOIN procedures p ON t.procedure_id=p.id JOIN procedure_costs pc ON p.id=pc.procedure_id WHERE t.visit_id = NEW.visit_id AND pc.end_date IS NULL);
        amount_medicines = (SELECT ROUND(SUM(mc.cost_per_unit * vm.units_given * (1-vm.discount))) FROM visit_medicines vm JOIN medicines m ON vm.medicine_id=m.id JOIN medicine_costs mc ON m.id=mc.medicine_id WHERE vm.visit_id = NEW.visit_id AND mc.end_date IS NULL);

        IF amount_treatments IS NULL AND amount_medicines IS NOT NULL THEN
            total_amount = amount_medicines;
        ELSIF amount_medicines IS NULL AND amount_treatments IS NOT NULL THEN
            total_amount = amount_treatments;
        ELSIF amount_medicines IS NULL AND amount_treatments IS NULL THEN
            total_amount = 0;
        ELSE
            total_amount = amount_treatments + amount_medicines;
        END IF; 
		UPDATE visits SET total_charge = total_amount WHERE id=last_visit;
	RETURN null;

	END;
	$$ LANGUAGE plpgsql;

CREATE TRIGGER update_total_costs_for_medicines_changes
AFTER UPDATE OR INSERT ON visit_medicines   
FOR EACH ROW
EXECUTE PROCEDURE calculate_total_costs();

CREATE TRIGGER update_total_costs_for_treatments_changes
AFTER UPDATE OR INSERT ON treatments
FOR EACH ROW
EXECUTE PROCEDURE calculate_total_costs();



-- calculate_overnight_stay
-- (associated with a trigger: update_overnight_stay_flag)
CREATE OR REPLACE FUNCTION calculate_overnight_stay() RETURNS TRIGGER AS $$
	DECLARE
		last_visit INTEGER;
		length_of_time INTEGER;
	BEGIN
		last_visit = NEW.visit_id;
		length_of_time = (SELECT SUM(p.length_of_time) FROM procedures p JOIN treatments t ON p.id=t.procedure_id WHERE t.visit_id=last_visit);
        IF (length_of_time) > 720 THEN 
			UPDATE visits SET overnight_stay = true WHERE id=last_visit;
        ELSE 
            UPDATE visits SET overnight_stay = false WHERE id=last_visit;
		END IF;
	 RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;

CREATE TRIGGER update_overnight_stay_flag
AFTER UPDATE OR INSERT ON treatments
FOR EACH ROW
EXECUTE PROCEDURE calculate_overnight_stay();


-- set_end_date_for_medicine_costs
-- (associated with a trigger: set_end_date_for_previous_medicine_cost)
CREATE OR REPLACE FUNCTION set_end_date_for_medicine_costs() RETURNS TRIGGER AS $$
    DECLARE
        old_cost_id INTEGER;
        new_cost_id INTEGER;
        med INTEGER;
    BEGIN
        new_cost_id = (SELECT currval(pg_get_serial_sequence('medicine_costs', 'id')));
        med = (SELECT medicine_id from medicine_costs where id = new_cost_id);
        old_cost_id = (SELECT id from medicine_costs where end_date is null and medicine_id = med and id !=new_cost_id);
        UPDATE medicine_costs SET end_date = current_date WHERE id = old_cost_id and med = medicine_id;
     RETURN NULL;
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER set_end_date_for_previous_medicine_cost
AFTER INSERT ON medicine_costs
EXECUTE PROCEDURE set_end_date_for_medicine_costs();

-- set_end_date_for_procedure_costs
-- (associated with a trigger: set_end_date_for_previous_procedure_cost)
CREATE OR REPLACE FUNCTION set_end_date_for_procedure_costs() RETURNS TRIGGER AS $$
    DECLARE
        old_cost_id INTEGER;
        new_cost_id INTEGER;
        pr INTEGER;
    BEGIN
        new_cost_id = (SELECT currval(pg_get_serial_sequence('procedure_costs', 'id')));
        pr = (SELECT procedure_id from procedure_costs where id = new_cost_id);
        old_cost_id = (SELECT id from procedure_costs where end_date is null and procedure_id = pr and id != new_cost_id);
        UPDATE procedure_costs SET end_date = current_date WHERE id = old_cost_id and pr = procedure_id;
     RETURN NULL;
    END;
    $$ LANGUAGE PLPGSQL;

CREATE TRIGGER set_end_date_for_previous_procedure_cost
AFTER INSERT ON procedure_costs
EXECUTE PROCEDURE set_end_date_for_procedure_costs();

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
CREATE OR REPLACE FUNCTION verify_that_medicine_requested_in_stock(medicine_id int, units_needed int) RETURNS BOOLEAN AS $$
	DECLARE
		stock_amount INTEGER;
		enough_medicine BOOLEAN;
	BEGIN
		stock_amount = (SELECT m.stock_amount FROM medicines m WHERE id=medicine_id);
		IF stock_amount >= units_needed THEN
			enough_medicine = true;
		ELSE
			enough_medicine = false;
		END IF;

	  RETURN enough_medicine;
	END;
	$$ LANGUAGE plpgsql;



-- verify_that_medicine_is_appropriate_for_pet
-- (takes medicine_id and pet_id as arguments and returns a boolean)
    CREATE OR REPLACE FUNCTION verify_that_medicine_is_appropriate_for_pet(meds int, pet int) RETURNS boolean AS $$
        DECLARE
            a_id INTEGER;
            r animal_medicines%rowtype;
        BEGIN
            a_id = (SELECT pets.animal_id FROM pets where pets.id = pet);
            FOR r in SELECT * FROM animal_medicines WHERE animal_id = a_id LOOP
                IF meds = r.medicine_id THEN
                    RETURN True; 
                END IF;
            END LOOP; 
         RETURN False;
        END;
        $$ LANGUAGE plpgsql; 




