--
-- PostgreSQL database dump
--

-- Dumped from database version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)
-- Dumped by pg_dump version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: department_machinery; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.department_machinery (
    id integer NOT NULL,
    machine_name character varying(150) NOT NULL,
    inventory_code character varying(50),
    department_id integer NOT NULL,
    usage_description text,
    brand character varying(100),
    model character varying(100),
    serial_number character varying(100),
    acquisition_date date,
    acquisition_cost numeric(15,2),
    machine_status character varying(50) DEFAULT 'Operational'::character varying,
    last_maintenance_date date,
    notes text,
    record_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_updated_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT department_machinery_machine_status_check CHECK (((machine_status)::text = ANY ((ARRAY['Operational'::character varying, 'Under Maintenance'::character varying, 'Damaged'::character varying, 'Obsolete'::character varying, 'Decommissioned'::character varying])::text[])))
);


ALTER TABLE public.department_machinery OWNER TO chepino;

--
-- Name: department_machinery_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.department_machinery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.department_machinery_id_seq OWNER TO chepino;

--
-- Name: department_machinery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.department_machinery_id_seq OWNED BY public.department_machinery.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    department_name character varying(100) NOT NULL,
    description text,
    location character varying(100),
    cost_center_code character varying(50),
    creation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.departments OWNER TO chepino;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departments_id_seq OWNER TO chepino;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    national_id_number character varying(20) NOT NULL,
    date_of_birth date,
    gender character(1),
    address text,
    phone_number character varying(20),
    corporate_email character varying(100),
    hire_date date DEFAULT CURRENT_DATE NOT NULL,
    department_id integer,
    position_id integer,
    supervisor_id integer,
    employee_status character varying(20) DEFAULT 'Active'::character varying,
    creation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_updated_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT employees_employee_status_check CHECK (((employee_status)::text = ANY ((ARRAY['Active'::character varying, 'Inactive'::character varying, 'Suspended'::character varying, 'Terminated'::character varying])::text[]))),
    CONSTRAINT employees_gender_check CHECK ((gender = ANY (ARRAY['M'::bpchar, 'F'::bpchar, 'O'::bpchar])))
);


ALTER TABLE public.employees OWNER TO chepino;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_id_seq OWNER TO chepino;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: positions; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.positions (
    id integer NOT NULL,
    position_title character varying(100) NOT NULL,
    responsibilities_description text,
    hierarchical_level integer,
    minimum_salary numeric(10,2),
    maximum_salary numeric(10,2),
    creation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT positions_check CHECK ((maximum_salary >= minimum_salary)),
    CONSTRAINT positions_minimum_salary_check CHECK ((minimum_salary >= (0)::numeric))
);


ALTER TABLE public.positions OWNER TO chepino;

--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.positions_id_seq OWNER TO chepino;

--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.positions_id_seq OWNED BY public.positions.id;


--
-- Name: salaries; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.salaries (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    salary_amount numeric(12,2) NOT NULL,
    effective_start_date date NOT NULL,
    effective_end_date date,
    currency_code character(3) DEFAULT 'USD'::bpchar NOT NULL,
    payment_frequency character varying(50) DEFAULT 'Monthly'::character varying,
    notes text,
    record_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_salary_dates CHECK (((effective_end_date IS NULL) OR (effective_end_date > effective_start_date))),
    CONSTRAINT salaries_payment_frequency_check CHECK (((payment_frequency)::text = ANY ((ARRAY['Weekly'::character varying, 'Bi-Weekly'::character varying, 'Monthly'::character varying, 'Annual'::character varying])::text[]))),
    CONSTRAINT salaries_salary_amount_check CHECK ((salary_amount >= (0)::numeric))
);


ALTER TABLE public.salaries OWNER TO chepino;

--
-- Name: salaries_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.salaries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.salaries_id_seq OWNER TO chepino;

--
-- Name: salaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.salaries_id_seq OWNED BY public.salaries.id;


--
-- Name: department_machinery id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.department_machinery ALTER COLUMN id SET DEFAULT nextval('public.department_machinery_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: positions id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.positions ALTER COLUMN id SET DEFAULT nextval('public.positions_id_seq'::regclass);


--
-- Name: salaries id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.salaries ALTER COLUMN id SET DEFAULT nextval('public.salaries_id_seq'::regclass);


--
-- Data for Name: department_machinery; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.department_machinery (id, machine_name, inventory_code, department_id, usage_description, brand, model, serial_number, acquisition_date, acquisition_cost, machine_status, last_maintenance_date, notes, record_date, last_updated_date) FROM stdin;
2	Laser Cutter Beta	LSCB002	1	Sheet metal cutting	Trumpf	TruLaser 3030	SNLSCB002	2019-08-10	250000.00	Operational	2024-01-20	\N	2025-05-28 11:58:04.407926	2025-05-28 11:58:04.407926
3	3D Printer DesignPro	3DPDP003	2	Prototyping and R&D	Stratasys	F170	SN3DPDP003	2020-02-01	35000.00	Operational	2023-11-05	\N	2025-05-28 11:58:04.407926	2025-05-28 11:58:04.407926
1	CNC Milling Machine Alpha	CNCMA001	1	Precision part manufacturing	Haas	VF-2	SNCNCMA001	2017-05-20	120000.00	Operational	2024-03-10	Returned to service after minor checkup.	2025-05-28 11:58:04.407926	2025-05-28 11:58:04.407926
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.departments (id, department_name, description, location, cost_center_code, creation_date) FROM stdin;
2	Engineering	Designs and improves products and machinery	Building B, Floor 2	ENG200	2025-05-28 11:58:04.39798
3	Human Resources	Manages employee relations and recruitment	Building C, Floor 1	HR300	2025-05-28 11:58:04.39798
4	Sales & Marketing	Promotes and sells company products	Building C, Floor 2	SM400	2025-05-28 11:58:04.39798
1	Manufacturing	Handles all production processes	Building A, Floor 1 - Main Office	MFG100	2025-05-28 11:58:04.39798
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.employees (id, first_name, last_name, national_id_number, date_of_birth, gender, address, phone_number, corporate_email, hire_date, department_id, position_id, supervisor_id, employee_status, creation_date, last_updated_date) FROM stdin;
2	Jane	Smith	NID12345602	1990-07-22	F	456 Engineer Blvd	555-1002	jane.smith@fabric.com	2018-01-10	2	2	\N	Active	2025-05-28 11:58:04.400755	2025-05-28 11:58:04.400755
3	Robert	Brown	NID12345603	1988-11-05	M	789 HR Lane	555-1003	robert.brown@fabric.com	2019-03-15	3	3	2	Active	2025-05-28 11:58:04.400755	2025-05-28 11:58:04.400755
4	Emily	White	NID12345604	1992-01-30	F	101 Sales St	555-1004	emily.white@fabric.com	2020-07-01	4	4	2	Active	2025-05-28 11:58:04.400755	2025-05-28 11:58:04.400755
1	John	Doe	NID12345601	1985-03-15	M	123 Production Way	555-999-0001	john.doe@fabric.com	2015-06-01	1	1	\N	Active	2025-05-28 11:58:04.400755	2025-05-28 11:58:04.400755
\.


--
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.positions (id, position_title, responsibilities_description, hierarchical_level, minimum_salary, maximum_salary, creation_date) FROM stdin;
2	Mechanical Engineer	Designs mechanical systems and components.	3	60000.00	90000.00	2025-05-28 11:58:04.39936
3	HR Specialist	Handles recruitment, onboarding, and employee benefits.	2	45000.00	65000.00	2025-05-28 11:58:04.39936
4	Sales Representative	Develops client relationships and achieves sales targets.	2	40000.00	75000.00	2025-05-28 11:58:04.39936
1	Machine Operator	Operates and maintains production machinery.	1	32000.00	48000.00	2025-05-28 11:58:04.39936
\.


--
-- Data for Name: salaries; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.salaries (id, employee_id, salary_amount, effective_start_date, effective_end_date, currency_code, payment_frequency, notes, record_date) FROM stdin;
2	2	75000.00	2018-01-10	\N	USD	Monthly	Initial salary for Jane Smith	2025-05-28 11:58:04.405187
3	3	55000.00	2019-03-15	\N	USD	Monthly	Initial salary for Robert Brown	2025-05-28 11:58:04.405187
4	4	60000.00	2020-07-01	\N	USD	Monthly	Initial salary for Emily White	2025-05-28 11:58:04.405187
1	1	42000.00	2015-06-01	\N	USD	Monthly	Salary adjustment for John Doe, effective 2024-04-01	2025-05-28 11:58:04.405187
\.


--
-- Name: department_machinery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.department_machinery_id_seq', 5, true);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.departments_id_seq', 5, true);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.employees_id_seq', 5, true);


--
-- Name: positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.positions_id_seq', 5, true);


--
-- Name: salaries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.salaries_id_seq', 5, true);


--
-- Name: department_machinery department_machinery_inventory_code_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.department_machinery
    ADD CONSTRAINT department_machinery_inventory_code_key UNIQUE (inventory_code);


--
-- Name: department_machinery department_machinery_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.department_machinery
    ADD CONSTRAINT department_machinery_pkey PRIMARY KEY (id);


--
-- Name: department_machinery department_machinery_serial_number_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.department_machinery
    ADD CONSTRAINT department_machinery_serial_number_key UNIQUE (serial_number);


--
-- Name: departments departments_department_name_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_department_name_key UNIQUE (department_name);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: employees employees_corporate_email_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_corporate_email_key UNIQUE (corporate_email);


--
-- Name: employees employees_national_id_number_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_national_id_number_key UNIQUE (national_id_number);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: positions positions_position_title_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_position_title_key UNIQUE (position_title);


--
-- Name: salaries salaries_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.salaries
    ADD CONSTRAINT salaries_pkey PRIMARY KEY (id);


--
-- Name: idx_employees_department; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_employees_department ON public.employees USING btree (department_id);


--
-- Name: idx_employees_email; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_employees_email ON public.employees USING btree (corporate_email);


--
-- Name: idx_employees_position; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_employees_position ON public.employees USING btree (position_id);


--
-- Name: idx_machinery_department; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_machinery_department ON public.department_machinery USING btree (department_id);


--
-- Name: idx_machinery_inventory_code; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_machinery_inventory_code ON public.department_machinery USING btree (inventory_code);


--
-- Name: idx_salaries_employee; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_salaries_employee ON public.salaries USING btree (employee_id);


--
-- Name: idx_salaries_start_date; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_salaries_start_date ON public.salaries USING btree (effective_start_date);


--
-- Name: employees fk_employee_department; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employee_department FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: employees fk_employee_position; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employee_position FOREIGN KEY (position_id) REFERENCES public.positions(id) ON DELETE SET NULL;


--
-- Name: employees fk_employee_supervisor; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employee_supervisor FOREIGN KEY (supervisor_id) REFERENCES public.employees(id) ON DELETE SET NULL;


--
-- Name: department_machinery fk_machinery_department; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.department_machinery
    ADD CONSTRAINT fk_machinery_department FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE RESTRICT;


--
-- Name: salaries fk_salary_employee; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.salaries
    ADD CONSTRAINT fk_salary_employee FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

