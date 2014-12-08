-- PRIVILEGES FOR pats USER OF PATS DATABASE
--
-- by Alex Mark & Graham Schilling
--
--
-- SQL needed to create the pats user

CREATE USER pats;


-- SQL to limit pats user access on key tables

REVOKE DELETE ON visit_medicines FROM pats;
REVOKE DELETE ON treatments FROM pats;

--revoke units_given in vist_medicines
REVOKE UPDATE (units_given) ON visit_medicines FROM pats;

--non superusers, select access only on users table
REVOKE ALL PRIVILEGES ON DATABASE phase_2 FROM Public;

GRANT SELECT ON users TO Public;