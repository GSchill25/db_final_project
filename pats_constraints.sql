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
ALTER TABLE medicineCosts 
ADD CONSTRAINT medicineCosts_fkey 
FOREIGN KEY (medicine_id) 
REFERENCES medicine(id)
ON DELETE restrict;

--procedureCosts
ALTER TABLE procedureCosts 
ADD CONSTRAINT procedureCosts_fkey 
FOREIGN KEY (procedure_id) 
REFERENCES procedures(id)
ON DELETE restrict;
