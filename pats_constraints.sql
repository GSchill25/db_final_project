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
ON DELETE restrict;

ALTER TABLE pets 
ADD CONSTRAINT pets_owners_fkey 
FOREIGN KEY (owner_id) 
REFERENCES owners(id)
ON DELETE restrict;

--visits fks
ALTER TABLE visits 
ADD CONSTRAINT visits_pets_fkey 
FOREIGN KEY (pet_id) 
REFERENCES pets(id)
ON DELETE restrict;

--medicineCosts fks
ALTER TABLE medicine_costs 
ADD CONSTRAINT medicine_costs_fkey 
FOREIGN KEY (medicine_id) 
REFERENCES medicines(id)
ON DELETE restrict;

--procedureCosts
ALTER TABLE procedure_costs 
ADD CONSTRAINT procedure_costs_fkey 
FOREIGN KEY (procedure_id) 
REFERENCES procedures(id)
ON DELETE restrict;

--visitMedicines composite key
ALTER TABLE visit_medicines
ADD CONSTRAINT visit_medicines_pkey
PRIMARY KEY (visit_id, medicine_id);

--treatment composite key
ALTER TABLE treatments
ADD CONSTRAINT treatments_pkey
PRIMARY KEY (visit_id, procedure_id);

--animal_medicines composite key
ALTER TABLE animal_medicines
ADD CONSTRAINT animal_medicines_pkey
PRIMARY KEY (animal_id, medicine_id);


