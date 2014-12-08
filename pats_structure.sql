-- TABLE STRUCTURE FOR PATS DATABASE
--
-- by Graham Schilling & Alex Mark
--
--

CREATE TABLE animals (
id SERIAL PRIMARY KEY NOT NULL,
name character varying(255) NOT NULL,
active boolean DEFAULT true NOT NULL);

CREATE TABLE pets(
id SERIAL PRIMARY KEY NOT NULL,
animal_id integer NOT NULL,
name character varying(255) NOT NULL,
owner_id integer NOT NULL,
female boolean NOT NULL,
date_of_birth date,
active boolean DEFAULT true NOT NULL);

CREATE TABLE owners(
id SERIAL PRIMARY KEY NOT NULL,
first_name character varying(255) NOT NULL,
last_name character varying(255) NOT NULL,
street character varying(255) NOT NULL,
city character varying(255) NOT NULL,
state character varying(255) DEFAULT 'PA' NOT NULL,
zip character varying(255) NOT NULL,
phone character varying(10),
email character varying(255),
active boolean DEFAULT true NOT NULL);

CREATE TABLE visits(
id SERIAL PRIMARY KEY NOT NULL,
pet_id integer NOT NULL,
date date NOT NULL,
weight numeric,
overnight_stay boolean DEFAULT false NOT NULL,
total_charge integer NOT NULL);

CREATE TABLE medicine_costs(
id SERIAL PRIMARY KEY NOT NULL,
medicine_id integer NOT NULL,
cost_per_unit integer NOT NULL,
start_date date NOT NULL,
end_date date);

CREATE TABLE medicines(
id SERIAL PRIMARY KEY NOT NULL,
name character varying(255) NOT NULL,
description text NOT NULL,
stock_amount integer NOT NULL,
method character varying(255) NOT NULL,
unit character varying(255) NOT NULL,
vaccine boolean DEFAULT false NOT NULL);

CREATE TABLE animal_medicines(
id SERIAL PRIMARY KEY NOT NULL,
animal_id integer NOT NULL,
medicine_id integer NOT NULL,
recommended_num_of_units numeric);

CREATE TABLE visit_medicines(
id serial PRIMARY KEY NOT NULL,
visit_id integer NOT NULL,
medicine_id integer NOT NULL,
units_given numeric NOT NULL,
discount numeric DEFAULT 0 NOT NULL);

CREATE TABLE notes (
id SERIAL PRIMARY KEY NOT NULL,
notable_type character varying(255) NOT NULL,
notable_id integer NOT NULL,
title character varying(255) NOT NULL,
content text NOT NULL,
user_id integer NOT NULL,
date date NOT NULL);

CREATE TABLE treatments(
id SERIAL PRIMARY KEY NOT NULL,
visit_id integer NOT NULL,
procedure_id integer NOT NULL,
successful boolean,
discount numeric DEFAULT 0 NOT NULL);

CREATE TABLE procedures(
id SERIAL PRIMARY KEY NOT NULL,
name character varying(255) NOT NULL,
description text,
length_of_time integer NOT NULL,
active boolean DEFAULT true NOT NULL);

CREATE TABLE procedure_costs(
id SERIAL PRIMARY KEY NOT NULL,
procedure_id integer NOT NULL,
cost integer NOT NULL,
start_date date NOT NULL,
end_date date); 

CREATE TABLE users(
id SERIAL PRIMARY KEY NOT NULL,
first_name character varying(255) NOT NULL,
last_name character varying(255) NOT NULL,
role character varying(255) NOT NULL,
username character varying(255) UNIQUE NOT NULL,
password_digest character varying(255) NOT NULL,
active boolean DEFAULT true NOT NULL);

