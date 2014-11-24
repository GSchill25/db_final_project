-- TABLE STRUCTURE FOR PATS DATABASE
--
-- by Graham Schilling & Alex Mark
--
--

CREATE TABLE animals (
id SERIAL PRIMARY KEY,
name character varying(255),
active boolean DEFAULT true);

CREATE TABLE pets(
id SERIAL PRIMARY KEY,
animal_id integer,
owner_id integer,
female boolean,
date_of_birth date,
active boolean DEFAULT true);

CREATE TABLE owners(
id SERIAL PRIMARY KEY,
first_name character varying(255),
last_name character varying(255),
street character varying(255),
city character varying(255),
state character varying(255) DEFAULT "PA",
zip character varying(255),
phone character varying(10),
email character varying(255),
active boolean DEFAULT true);

CREATE TABLE visits(
id SERIAL PRIMARY KEY,
pet_id integer,
date date,
weight numeric,
overnight_stay boolean,
total_charge integer);

CREATE TABLE medicineCosts(
id SERIAL PRIMARY KEY,
medicine_id integer,
cost_per_unit integer,
start_date date,
end_date date);

CREATE TABLE medicines(
id SERIAL PRIMARY KEY,
name character varying(255),
description text,
stock_amount integer,
method character varying(255),
unit character varying(255),
vaccine boolean DEFAULT false);

CREATE TABLE animalMedicines(
id SERIAL PRIMARY KEY,
animal_id integer,
medicine_id integer,
recommended_num_of_units numeric);

CREATE TABLE visitMedicines(
id SERIAL PRIMARY KEY,
visit_id integer,
medicine_id integer,
units_given numeric,
discount numeric DEFAULT 0);

CREATE TABLE notes (
id SERIAL PRIMARY KEY,
notable_type character varying(255),
notable_id integer,
title character varying(255),
content text,
user_id integer,
date date);

CREATE TABLE treatments (
id SERIAL PRIMARY KEY,
visit_id integer,
procedure_id integer,
successful boolean,
discount numeric DEFAULT 0);

CREATE TABLE procedures (
id SERIAL PRIMARY KEY,
name character varying(255),
description text,
length_of_time integer,
active boolean DEFAULT true);

CREATE TABLE procedureCosts(
id SERIAL PRIMARY KEY,
procedure_id integer,
cost integer,
start_date date,
end_date date);

CREATE TABLE users(
id SERIAL PRIMARY KEY,
first_name character varying(255),
last_name character varying(255),
role character varying(255),
username character varying(255) UNIQUE,
password_digest character varying(255),
active boolean DEFAULT true);
