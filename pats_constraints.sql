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