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
-- Name: applied_treatments; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.applied_treatments (
    id integer NOT NULL,
    medical_record_id integer,
    appointment_id integer,
    treatment_id integer NOT NULL,
    treatment_start_date date NOT NULL,
    treatment_end_date date,
    treatment_status character varying(50) DEFAULT 'Prescribed'::character varying,
    treatment_notes text,
    prescribing_doctor_id integer,
    CONSTRAINT applied_treatments_treatment_status_check CHECK (((treatment_status)::text = ANY ((ARRAY['Prescribed'::character varying, 'In Progress'::character varying, 'Completed'::character varying, 'Suspended'::character varying, 'Cancelled'::character varying])::text[]))),
    CONSTRAINT chk_record_or_appointment CHECK ((((medical_record_id IS NOT NULL) AND (appointment_id IS NULL)) OR ((medical_record_id IS NULL) AND (appointment_id IS NOT NULL)) OR ((medical_record_id IS NOT NULL) AND (appointment_id IS NOT NULL))))
);


ALTER TABLE public.applied_treatments OWNER TO chepino;

--
-- Name: applied_treatments_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.applied_treatments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.applied_treatments_id_seq OWNER TO chepino;

--
-- Name: applied_treatments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.applied_treatments_id_seq OWNED BY public.applied_treatments.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.appointments (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    doctor_id integer NOT NULL,
    appointment_datetime timestamp without time zone NOT NULL,
    reason_for_visit text,
    appointment_status character varying(20) DEFAULT 'Scheduled'::character varying,
    appointment_notes text,
    CONSTRAINT appointments_appointment_status_check CHECK (((appointment_status)::text = ANY ((ARRAY['Scheduled'::character varying, 'Confirmed'::character varying, 'Cancelled'::character varying, 'Completed'::character varying, 'No Show'::character varying])::text[])))
);


ALTER TABLE public.appointments OWNER TO chepino;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointments_id_seq OWNER TO chepino;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.doctors (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    specialty_id integer,
    phone_number character varying(20),
    email character varying(100),
    professional_license_number character varying(50)
);


ALTER TABLE public.doctors OWNER TO chepino;

--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.doctors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctors_id_seq OWNER TO chepino;

--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.doctors_id_seq OWNED BY public.doctors.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.invoices (
    id integer NOT NULL,
    appointment_id integer,
    patient_id integer NOT NULL,
    issue_date date DEFAULT CURRENT_DATE NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    payment_status character varying(20) DEFAULT 'Pending'::character varying,
    payment_method character varying(50),
    payment_date date,
    payment_reference character varying(100),
    invoice_notes text,
    CONSTRAINT invoices_payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['Pending'::character varying, 'Paid'::character varying, 'Partially Paid'::character varying, 'Cancelled'::character varying, 'Refunded'::character varying])::text[])))
);


ALTER TABLE public.invoices OWNER TO chepino;

--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.invoices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invoices_id_seq OWNER TO chepino;

--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: medical_records; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.medical_records (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    creation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    personal_history text,
    family_history text,
    allergies text,
    general_notes text
);


ALTER TABLE public.medical_records OWNER TO chepino;

--
-- Name: medical_records_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.medical_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medical_records_id_seq OWNER TO chepino;

--
-- Name: medical_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.medical_records_id_seq OWNED BY public.medical_records.id;


--
-- Name: office_assignments; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.office_assignments (
    id integer NOT NULL,
    doctor_id integer NOT NULL,
    office_identifier character varying(20) NOT NULL,
    start_datetime timestamp without time zone NOT NULL,
    end_datetime timestamp without time zone NOT NULL,
    patients_seen_in_session integer DEFAULT 0,
    session_notes text,
    CONSTRAINT chk_assignment_datetimes CHECK ((end_datetime > start_datetime))
);


ALTER TABLE public.office_assignments OWNER TO chepino;

--
-- Name: office_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.office_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.office_assignments_id_seq OWNER TO chepino;

--
-- Name: office_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.office_assignments_id_seq OWNED BY public.office_assignments.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.patients (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    date_of_birth date NOT NULL,
    gender character(1),
    address text,
    phone_number character varying(20),
    email character varying(100),
    social_security_number character varying(50),
    CONSTRAINT patients_gender_check CHECK ((gender = ANY (ARRAY['M'::bpchar, 'F'::bpchar, 'O'::bpchar])))
);


ALTER TABLE public.patients OWNER TO chepino;

--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.patients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patients_id_seq OWNER TO chepino;

--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.patients_id_seq OWNED BY public.patients.id;


--
-- Name: specialties; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.specialties (
    id integer NOT NULL,
    specialty_name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.specialties OWNER TO chepino;

--
-- Name: specialties_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.specialties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.specialties_id_seq OWNER TO chepino;

--
-- Name: specialties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.specialties_id_seq OWNED BY public.specialties.id;


--
-- Name: treatments; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.treatments (
    id integer NOT NULL,
    treatment_name character varying(255) NOT NULL,
    treatment_description text,
    estimated_cost numeric(10,2)
);


ALTER TABLE public.treatments OWNER TO chepino;

--
-- Name: treatments_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.treatments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.treatments_id_seq OWNER TO chepino;

--
-- Name: treatments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.treatments_id_seq OWNED BY public.treatments.id;


--
-- Name: applied_treatments id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.applied_treatments ALTER COLUMN id SET DEFAULT nextval('public.applied_treatments_id_seq'::regclass);


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: doctors id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.doctors ALTER COLUMN id SET DEFAULT nextval('public.doctors_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: medical_records id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.medical_records ALTER COLUMN id SET DEFAULT nextval('public.medical_records_id_seq'::regclass);


--
-- Name: office_assignments id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.office_assignments ALTER COLUMN id SET DEFAULT nextval('public.office_assignments_id_seq'::regclass);


--
-- Name: patients id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.patients ALTER COLUMN id SET DEFAULT nextval('public.patients_id_seq'::regclass);


--
-- Name: specialties id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.specialties ALTER COLUMN id SET DEFAULT nextval('public.specialties_id_seq'::regclass);


--
-- Name: treatments id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.treatments ALTER COLUMN id SET DEFAULT nextval('public.treatments_id_seq'::regclass);


--
-- Data for Name: applied_treatments; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.applied_treatments (id, medical_record_id, appointment_id, treatment_id, treatment_start_date, treatment_end_date, treatment_status, treatment_notes, prescribing_doctor_id) FROM stdin;
2	2	2	2	2024-08-01	\N	In Progress	Neurological exam initiated.	2
3	1	3	1	2024-08-02	\N	Prescribed	Further heart monitoring advised.	3
4	4	4	3	2024-08-03	\N	Completed	Vaccines administered as scheduled.	4
1	1	1	1	2024-08-01	\N	In Progress	ECG performed during appointment.	1
\.


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.appointments (id, patient_id, doctor_id, appointment_datetime, reason_for_visit, appointment_status, appointment_notes) FROM stdin;
2	2	2	2024-08-01 11:00:00	Headache consultation	Confirmed	Persistent headaches for 2 weeks.
3	1	3	2024-08-02 09:30:00	Follow-up cardiology	Scheduled	Review test results.
4	4	4	2024-08-03 14:00:00	Child vaccination	Completed	Routine vaccinations administered.
1	1	1	2024-08-01 10:00:00	Chest pain evaluation	Confirmed	Patient reports intermittent chest pain.
\.


--
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.doctors (id, first_name, last_name, specialty_id, phone_number, email, professional_license_number) FROM stdin;
2	Jane	Smith	2	555-0102	jane.smith@example.com	MD1002
3	Alice	Brown	1	555-0103	alice.brown@example.com	MD1003
4	Bob	White	3	555-0104	bob.white@example.com	MD1004
1	John	Doe	1	555-0199	john.doe@example.com	MD1001
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.invoices (id, appointment_id, patient_id, issue_date, total_amount, payment_status, payment_method, payment_date, payment_reference, invoice_notes) FROM stdin;
2	2	2	2025-05-23	150.00	Paid	Credit Card	\N	\N	\N
3	3	1	2025-05-23	50.00	Pending	\N	\N	\N	\N
4	4	4	2025-05-23	120.00	Paid	Insurance	\N	\N	\N
1	1	1	2025-05-23	70.00	Partially Paid	\N	\N	\N	\N
\.


--
-- Data for Name: medical_records; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.medical_records (id, patient_id, creation_date, personal_history, family_history, allergies, general_notes) FROM stdin;
2	2	2025-05-23 18:29:47.173002	Asthma diagnosed in childhood.	Mother had diabetes.	None known.	Follow-up for asthma.
3	3	2025-05-23 18:29:47.173002	Previous knee surgery.	No significant family history.	Sulfa drugs.	Post-surgery check-up.
4	4	2025-05-23 18:29:47.173002	Generally healthy.	Grandmother had breast cancer.	None known.	Routine physical.
1	1	2025-05-23 18:29:47.173002	Healthy, non-smoker.	Father had hypertension.	Penicillin, Aspirin	Annual check-up.
\.


--
-- Data for Name: office_assignments; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.office_assignments (id, doctor_id, office_identifier, start_datetime, end_datetime, patients_seen_in_session, session_notes) FROM stdin;
2	2	Office 102	2024-08-01 09:00:00	2024-08-01 13:00:00	0	Neurology consultations
3	3	Office 101	2024-08-02 08:00:00	2024-08-02 12:00:00	0	Cardiology follow-ups
4	4	Office 201	2024-08-03 13:00:00	2024-08-03 17:00:00	0	Pediatric clinic
1	1	Clinic Room A	2024-08-01 08:00:00	2024-08-01 12:00:00	0	Morning clinic session
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.patients (id, first_name, last_name, date_of_birth, gender, address, phone_number, email, social_security_number) FROM stdin;
2	Laura	Gomez	1992-03-22	F	456 Pine St, Townsville	555-0202	laura.gomez@example.com	SSN002
3	Pedro	Martinez	1978-11-01	M	789 Maple Ave, Villagetown	555-0203	pedro.martinez@example.com	SSN003
4	Sofia	Lopez	2001-07-30	F	101 Elm Rd, Boroughburg	555-0204	sofia.lopez@example.com	SSN004
1	Carlos	Rivera	1985-06-15	M	123 Oak Street, New Cityville	555-0201	carlos.rivera@example.com	SSN001
\.


--
-- Data for Name: specialties; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.specialties (id, specialty_name, description) FROM stdin;
2	Neurology	Branch of medicine dealing with disorders of the nervous system.
3	Pediatrics	Branch of medicine dealing with children and their diseases.
4	Oncology	Branch of medicine that deals with tumors and cancer.
1	Cardiology	Specialized in heart and blood vessel diseases.
\.


--
-- Data for Name: treatments; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.treatments (id, treatment_name, treatment_description, estimated_cost) FROM stdin;
2	Neurological Exam	Comprehensive assessment of neurological function.	150.00
3	Standard Vaccination Set	Set of standard childhood vaccines.	120.00
4	Biopsy of Skin Lesion	Removal and examination of a skin sample.	200.00
1	ECG Test	Electrocardiogram to check heart rhythm.	80.00
\.


--
-- Name: applied_treatments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.applied_treatments_id_seq', 5, true);


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.appointments_id_seq', 5, true);


--
-- Name: doctors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.doctors_id_seq', 5, true);


--
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.invoices_id_seq', 5, true);


--
-- Name: medical_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.medical_records_id_seq', 5, true);


--
-- Name: office_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.office_assignments_id_seq', 5, true);


--
-- Name: patients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.patients_id_seq', 5, true);


--
-- Name: specialties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.specialties_id_seq', 5, true);


--
-- Name: treatments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.treatments_id_seq', 5, true);


--
-- Name: applied_treatments applied_treatments_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.applied_treatments
    ADD CONSTRAINT applied_treatments_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_email_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_email_key UNIQUE (email);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_professional_license_number_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_professional_license_number_key UNIQUE (professional_license_number);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: medical_records medical_records_patient_id_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_patient_id_key UNIQUE (patient_id);


--
-- Name: medical_records medical_records_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_pkey PRIMARY KEY (id);


--
-- Name: office_assignments office_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.office_assignments
    ADD CONSTRAINT office_assignments_pkey PRIMARY KEY (id);


--
-- Name: patients patients_email_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_email_key UNIQUE (email);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: patients patients_social_security_number_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_social_security_number_key UNIQUE (social_security_number);


--
-- Name: specialties specialties_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.specialties
    ADD CONSTRAINT specialties_pkey PRIMARY KEY (id);


--
-- Name: specialties specialties_specialty_name_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.specialties
    ADD CONSTRAINT specialties_specialty_name_key UNIQUE (specialty_name);


--
-- Name: treatments treatments_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.treatments
    ADD CONSTRAINT treatments_pkey PRIMARY KEY (id);


--
-- Name: treatments treatments_treatment_name_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.treatments
    ADD CONSTRAINT treatments_treatment_name_key UNIQUE (treatment_name);


--
-- Name: idx_appointments_datetime; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_appointments_datetime ON public.appointments USING btree (appointment_datetime);


--
-- Name: idx_appointments_doctor_datetime; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_appointments_doctor_datetime ON public.appointments USING btree (doctor_id, appointment_datetime);


--
-- Name: idx_appointments_patient_datetime; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_appointments_patient_datetime ON public.appointments USING btree (patient_id, appointment_datetime);


--
-- Name: idx_assignment_doctor_datetime; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_assignment_doctor_datetime ON public.office_assignments USING btree (doctor_id, start_datetime);


--
-- Name: idx_invoice_patient; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_invoice_patient ON public.invoices USING btree (patient_id);


--
-- Name: idx_invoice_payment_status; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_invoice_payment_status ON public.invoices USING btree (payment_status);


--
-- Name: applied_treatments fk_applied_treatment_appointment; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.applied_treatments
    ADD CONSTRAINT fk_applied_treatment_appointment FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE SET NULL;


--
-- Name: applied_treatments fk_applied_treatment_catalog; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.applied_treatments
    ADD CONSTRAINT fk_applied_treatment_catalog FOREIGN KEY (treatment_id) REFERENCES public.treatments(id) ON DELETE RESTRICT;


--
-- Name: applied_treatments fk_applied_treatment_medical_record; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.applied_treatments
    ADD CONSTRAINT fk_applied_treatment_medical_record FOREIGN KEY (medical_record_id) REFERENCES public.medical_records(id) ON DELETE CASCADE;


--
-- Name: applied_treatments fk_applied_treatment_prescribing_doctor; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.applied_treatments
    ADD CONSTRAINT fk_applied_treatment_prescribing_doctor FOREIGN KEY (prescribing_doctor_id) REFERENCES public.doctors(id) ON DELETE SET NULL;


--
-- Name: appointments fk_appointment_doctor; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE RESTRICT;


--
-- Name: appointments fk_appointment_patient; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- Name: office_assignments fk_assignment_doctor; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.office_assignments
    ADD CONSTRAINT fk_assignment_doctor FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE CASCADE;


--
-- Name: doctors fk_doctor_specialty; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT fk_doctor_specialty FOREIGN KEY (specialty_id) REFERENCES public.specialties(id) ON DELETE SET NULL;


--
-- Name: invoices fk_invoice_appointment; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT fk_invoice_appointment FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE SET NULL;


--
-- Name: invoices fk_invoice_patient; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT fk_invoice_patient FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE RESTRICT;


--
-- Name: medical_records fk_medical_record_patient; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT fk_medical_record_patient FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

