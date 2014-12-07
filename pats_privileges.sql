-- PRIVILEGES FOR pats USER OF PATS DATABASE
--
-- by (student_1) & (student_2)
--
--
-- SQL needed to create the pats user

CREATE USER pats WITH LOGIN ENCRYPTED PASSWORD 'password';


-- SQL to limit pats user access on key tables

REVOKE UPDATE, INSERT ON table_name FROM pats;
REVOKE UPDATE, INSERT ON table_name FROM pats;