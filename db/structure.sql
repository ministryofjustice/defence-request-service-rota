--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: journal_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE journal_entries (
    id integer NOT NULL,
    procurement_area_id integer NOT NULL,
    total_slots integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    status character varying
);


--
-- Name: journal_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE journal_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: journal_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE journal_entries_id_seq OWNED BY journal_entries.id;


--
-- Name: organisations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organisations (
    id integer NOT NULL,
    name character varying NOT NULL,
    organisation_type character varying NOT NULL,
    tel character varying,
    address text,
    postcode character varying,
    email character varying,
    mobile character varying,
    procurement_area_id integer
);


--
-- Name: organisations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organisations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organisations_id_seq OWNED BY organisations.id;


--
-- Name: procurement_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE procurement_areas (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: procurement_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE procurement_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: procurement_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE procurement_areas_id_seq OWNED BY procurement_areas.id;


--
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE que_jobs (
    priority smallint DEFAULT 100 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    job_id bigint NOT NULL,
    job_class text NOT NULL,
    args json DEFAULT '[]'::json NOT NULL,
    error_count integer DEFAULT 0 NOT NULL,
    last_error text,
    queue text DEFAULT ''::text NOT NULL
);


--
-- Name: TABLE que_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE que_jobs IS '3';


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE que_jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE que_jobs_job_id_seq OWNED BY que_jobs.job_id;


--
-- Name: rota_slots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rota_slots (
    id integer NOT NULL,
    shift_id integer NOT NULL,
    procurement_area_id integer,
    starting_time timestamp without time zone,
    ending_time timestamp without time zone,
    request_count integer DEFAULT 0 NOT NULL,
    solicitor_name character varying,
    organisation_id integer
);


--
-- Name: rota_slots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rota_slots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rota_slots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rota_slots_id_seq OWNED BY rota_slots.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: shifts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shifts (
    id integer NOT NULL,
    name character varying,
    starting_time time without time zone,
    ending_time time without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    allocation_requirements_per_weekday jsonb DEFAULT '{}'::jsonb,
    organisation_id integer
);


--
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shifts_id_seq OWNED BY shifts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    name character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY journal_entries ALTER COLUMN id SET DEFAULT nextval('journal_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organisations ALTER COLUMN id SET DEFAULT nextval('organisations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY procurement_areas ALTER COLUMN id SET DEFAULT nextval('procurement_areas_id_seq'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_jobs ALTER COLUMN job_id SET DEFAULT nextval('que_jobs_job_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rota_slots ALTER COLUMN id SET DEFAULT nextval('rota_slots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shifts ALTER COLUMN id SET DEFAULT nextval('shifts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: journal_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY journal_entries
    ADD CONSTRAINT journal_entries_pkey PRIMARY KEY (id);


--
-- Name: organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


--
-- Name: procurement_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY procurement_areas
    ADD CONSTRAINT procurement_areas_pkey PRIMARY KEY (id);


--
-- Name: que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id);


--
-- Name: rota_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rota_slots
    ADD CONSTRAINT rota_slots_pkey PRIMARY KEY (id);


--
-- Name: shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_rota_slots_on_procurement_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rota_slots_on_procurement_area_id ON rota_slots USING btree (procurement_area_id);


--
-- Name: index_shifts_on_allocation_requirements_per_weekday; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shifts_on_allocation_requirements_per_weekday ON shifts USING gin (allocation_requirements_per_weekday);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_2c199e4b7c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rota_slots
    ADD CONSTRAINT fk_rails_2c199e4b7c FOREIGN KEY (procurement_area_id) REFERENCES procurement_areas(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150424184044');

INSERT INTO schema_migrations (version) VALUES ('20150501145629');

INSERT INTO schema_migrations (version) VALUES ('20150505143151');

INSERT INTO schema_migrations (version) VALUES ('20150506155028');

INSERT INTO schema_migrations (version) VALUES ('20150508101320');

INSERT INTO schema_migrations (version) VALUES ('20150512143730');

INSERT INTO schema_migrations (version) VALUES ('20150519154557');

INSERT INTO schema_migrations (version) VALUES ('20150528120346');

INSERT INTO schema_migrations (version) VALUES ('20150609085241');

INSERT INTO schema_migrations (version) VALUES ('20150612082011');

INSERT INTO schema_migrations (version) VALUES ('20150619122632');

INSERT INTO schema_migrations (version) VALUES ('20150622154137');

INSERT INTO schema_migrations (version) VALUES ('20150629122022');

INSERT INTO schema_migrations (version) VALUES ('20150629131833');

INSERT INTO schema_migrations (version) VALUES ('20150629142855');

INSERT INTO schema_migrations (version) VALUES ('20150629143621');

INSERT INTO schema_migrations (version) VALUES ('20150630103226');

INSERT INTO schema_migrations (version) VALUES ('20150630151128');

INSERT INTO schema_migrations (version) VALUES ('20150706141631');

