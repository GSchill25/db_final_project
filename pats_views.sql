-- VIEWS FOR PATS DATABASE
--
-- by Graham Schilling & Alex Mark
--
--


CREATE VIEW owners_view as
	SELECT o.first_name, o.last_name, o.street, o.city, o.state, o.zip, o.phone, o.email, o.active AS "Owner Active",
	p.name AS "Pet", p.female, p.date_of_birth, p.active AS "Pet Active", a.name AS "Animal", v.date, v.weight, v.overnight_stay, v.total_charge
	FROM owners o JOIN pets p ON o.id=p.owner_id LEFT JOIN visits v ON p.id=v.pet_id
	JOIN animals a ON a.id=p.animal_id;


CREATE VIEW medicines_view as
	SELECT m.name AS "Medicine", m.description, m.stock_amount, m.method, m.unit, m.vaccine,
	mc.cost_per_unit AS "Current Cost", mc.start_date, a.name, am.recommended_num_of_units
	FROM medicines m JOIN medicine_costs mc ON m.id=mc.medicine_id JOIN animal_medicines am ON
	m.id=am.medicine_id JOIN animals a ON am.animal_id=a.id 
	WHERE mc.end_date IS NULL;