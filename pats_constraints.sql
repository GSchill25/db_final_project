-- CONSTRAINTS FOR PATS DATABASE
--
-- by Graham Schilling & Alex Mark
--
--

--pets fks
ALTER TABLE pets 
ADD CONSTRAINT pets_animals_fkey 
FOREIGN KEY (animal_id) 
REFERENCES animals(id)
ON DELETE restrict ON UPDATE cascade;

ALTER TABLE pets 
ADD CONSTRAINT pets_owners_fkey 
FOREIGN KEY (owner_id) 
REFERENCES owners(id)
ON DELETE restrict ON UPDATE cascade;

--visits fks
ALTER TABLE visits 
ADD CONSTRAINT visits_pets_fkey 
FOREIGN KEY (pet_id) 
REFERENCES pets(id)
ON DELETE restrict ON UPDATE cascade;

--medicineCosts fks
ALTER TABLE medicine_costs 
ADD CONSTRAINT medicine_costs_fkey 
FOREIGN KEY (medicine_id) 
REFERENCES medicines(id)
ON DELETE restrict ON UPDATE cascade;

--procedureCosts
ALTER TABLE procedure_costs 
ADD CONSTRAINT procedure_costs_fkey 
FOREIGN KEY (procedure_id) 
REFERENCES procedures(id)
ON DELETE restrict ON UPDATE cascade;

--animalMedicine
ALTER TABLE animal_medicines
ADD CONSTRAINT animal_fkey
FOREIGN KEY (animal_id)
REFERENCES animals(id)
ON DELETE restrict ON UPDATE cascade;

ALTER TABLE animal_medicines
ADD CONSTRAINT medicine_fkey
FOREIGN KEY (medicine_id)
REFERENCES medicines(id)
ON DELETE restrict ON UPDATE cascade;

--visitMedicine
ALTER TABLE visit_medicines
ADD CONSTRAINT visit_fkey
FOREIGN KEY (visit_id)
REFERENCES visits(id)
ON DELETE restrict ON UPDATE cascade;

ALTER TABLE visit_medicines
ADD CONSTRAINT medicine_fkey
FOREIGN KEY (medicine_id)
REFERENCES medicines(id)
ON DELETE restrict ON UPDATE cascade;

--treatment
ALTER TABLE treatments
ADD CONSTRAINT visit_treat_fkey
FOREIGN KEY (visit_id)
REFERENCES visits(id)
ON DELETE restrict ON UPDATE cascade;

ALTER TABLE treatments
ADD CONSTRAINT procedure_fkey
FOREIGN KEY (procedure_id)
REFERENCES procedures(id)
ON DELETE restrict ON UPDATE cascade;

--notes
ALTER TABLE notes
ADD CONSTRAINT user_fkey
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE restrict ON UPDATE cascade;

ALTER TABLE medicine_costs ADD CONSTRAINT validate_cost_per_unit CHECK (cost_per_unit>=0);

ALTER TABLE animal_medicines ADD CONSTRAINT val_rec_units CHECK (recommended_num_of_units>=0);

ALTER TABLE medicines ADD CONSTRAINT val_stock CHECK (stock_amount>=0);

ALTER TABLE visit_medicines ADD CONSTRAINT val_units_given CHECK (units_given>=0);

ALTER TABLE visits ADD CONSTRAINT val_weight CHECK (weight>0);

ALTER TABLE visits ADD CONSTRAINT val_total_charge CHECK (total_charge>=0);

ALTER TABLE procedure_costs ADD CONSTRAINT val_cost CHECK (cost>=0);

ALTER TABLE procedures ADD CONSTRAINT val_length_of_time CHECK (length_of_time>=0);

ALTER TABLE medicines ADD CONSTRAINT val_method CHECK (method IN ('oral','injection', 'intravenous'));

ALTER TABLE visit_medicines ADD CHECK (discount BETWEEN 0 AND 1);

ALTER TABLE treatments ADD CHECK (discount BETWEEN 0 AND 1);


