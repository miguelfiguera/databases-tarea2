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
-- Name: aisle_categories; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.aisle_categories (
    aisle_id integer NOT NULL,
    category_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.aisle_categories OWNER TO chepino;

--
-- Name: aisles; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.aisles (
    id integer NOT NULL,
    aisle_number character varying(10) NOT NULL,
    number_of_shelves integer NOT NULL,
    rows_per_shelf integer NOT NULL,
    location_description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT aisles_number_of_shelves_check CHECK ((number_of_shelves > 0)),
    CONSTRAINT aisles_rows_per_shelf_check CHECK ((rows_per_shelf > 0))
);


ALTER TABLE public.aisles OWNER TO chepino;

--
-- Name: aisles_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.aisles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.aisles_id_seq OWNER TO chepino;

--
-- Name: aisles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.aisles_id_seq OWNED BY public.aisles.id;


--
-- Name: book_categories; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.book_categories (
    book_id integer NOT NULL,
    category_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.book_categories OWNER TO chepino;

--
-- Name: books; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.books (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    publication_year integer,
    isbn character varying(20),
    call_number character varying(50) NOT NULL,
    publisher character varying(150),
    edition character varying(50),
    language character varying(50),
    number_of_pages integer,
    summary text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT books_number_of_pages_check CHECK ((number_of_pages > 0)),
    CONSTRAINT books_publication_year_check CHECK (((publication_year > 0) AND ((publication_year)::double precision <= (date_part('year'::text, CURRENT_DATE) + (1)::double precision))))
);


ALTER TABLE public.books OWNER TO chepino;

--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.books_id_seq OWNER TO chepino;

--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    category_name character varying(100) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.categories OWNER TO chepino;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO chepino;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.inventory (
    id integer NOT NULL,
    book_id integer NOT NULL,
    aisle_id integer,
    shelf_number integer,
    row_number integer,
    copy_number integer DEFAULT 1,
    acquisition_date date,
    condition character varying(50) DEFAULT 'Good'::character varying,
    status character varying(20) DEFAULT 'Available'::character varying,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT inventory_condition_check CHECK (((condition)::text = ANY ((ARRAY['New'::character varying, 'Good'::character varying, 'Fair'::character varying, 'Poor'::character varying, 'Damaged'::character varying, 'Lost'::character varying])::text[]))),
    CONSTRAINT inventory_status_check CHECK (((status)::text = ANY ((ARRAY['Available'::character varying, 'On Loan'::character varying, 'Reserved'::character varying, 'In Repair'::character varying, 'Lost'::character varying])::text[])))
);


ALTER TABLE public.inventory OWNER TO chepino;

--
-- Name: inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_id_seq OWNER TO chepino;

--
-- Name: inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.inventory_id_seq OWNED BY public.inventory.id;


--
-- Name: library_users; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.library_users (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone_number character varying(20),
    address text,
    membership_id character varying(50) NOT NULL,
    join_date date DEFAULT CURRENT_DATE,
    status character varying(20) DEFAULT 'Active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT library_users_status_check CHECK (((status)::text = ANY ((ARRAY['Active'::character varying, 'Suspended'::character varying, 'Inactive'::character varying])::text[])))
);


ALTER TABLE public.library_users OWNER TO chepino;

--
-- Name: library_users_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.library_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_users_id_seq OWNER TO chepino;

--
-- Name: library_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.library_users_id_seq OWNED BY public.library_users.id;


--
-- Name: loans; Type: TABLE; Schema: public; Owner: chepino
--

CREATE TABLE public.loans (
    id integer NOT NULL,
    inventory_id integer NOT NULL,
    user_id integer NOT NULL,
    loan_date date DEFAULT CURRENT_DATE NOT NULL,
    due_date date NOT NULL,
    return_date date,
    status character varying(20) DEFAULT 'Active'::character varying,
    fine_amount numeric(8,2) DEFAULT 0.00,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_loan_dates CHECK ((due_date >= loan_date)),
    CONSTRAINT chk_return_date CHECK (((return_date IS NULL) OR (return_date >= loan_date))),
    CONSTRAINT loans_status_check CHECK (((status)::text = ANY ((ARRAY['Active'::character varying, 'Returned'::character varying, 'Overdue'::character varying, 'Lost'::character varying])::text[])))
);


ALTER TABLE public.loans OWNER TO chepino;

--
-- Name: loans_id_seq; Type: SEQUENCE; Schema: public; Owner: chepino
--

CREATE SEQUENCE public.loans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.loans_id_seq OWNER TO chepino;

--
-- Name: loans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chepino
--

ALTER SEQUENCE public.loans_id_seq OWNED BY public.loans.id;


--
-- Name: aisles id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.aisles ALTER COLUMN id SET DEFAULT nextval('public.aisles_id_seq'::regclass);


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: inventory id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.inventory ALTER COLUMN id SET DEFAULT nextval('public.inventory_id_seq'::regclass);


--
-- Name: library_users id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.library_users ALTER COLUMN id SET DEFAULT nextval('public.library_users_id_seq'::regclass);


--
-- Name: loans id; Type: DEFAULT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.loans ALTER COLUMN id SET DEFAULT nextval('public.loans_id_seq'::regclass);


--
-- Data for Name: aisle_categories; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.aisle_categories (aisle_id, category_id, created_at) FROM stdin;
2	2	2025-05-28 11:57:45.948872
3	3	2025-05-28 11:57:45.948872
4	4	2025-05-28 11:57:45.948872
1	2	2025-05-28 11:57:45.948872
\.


--
-- Data for Name: aisles; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.aisles (id, aisle_number, number_of_shelves, rows_per_shelf, location_description, created_at, updated_at) FROM stdin;
2	B2	6	4	Non-Fiction, 1st Floor West	2025-05-28 11:57:45.929622	2025-05-28 11:57:45.929622
3	C3	4	3	Science & Technology, 2nd Floor North	2025-05-28 11:57:45.929622	2025-05-28 11:57:45.929622
4	D4	5	2	History & Biographies, 2nd Floor South	2025-05-28 11:57:45.929622	2025-05-28 11:57:45.929622
1	A1	5	3	Fiction Section, 1st Floor East Wing	2025-05-28 11:57:45.929622	2025-05-28 11:57:45.929622
\.


--
-- Data for Name: book_categories; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.book_categories (book_id, category_id, created_at) FROM stdin;
2	1	2025-05-28 11:57:45.947608
3	1	2025-05-28 11:57:45.947608
4	3	2025-05-28 11:57:45.947608
1	2	2025-05-28 11:57:45.947608
\.


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.books (id, title, author, publication_year, isbn, call_number, publisher, edition, language, number_of_pages, summary, created_at, updated_at) FROM stdin;
2	To Kill a Mockingbird	Harper Lee	1960	978-0061120084	FIC LEE 1960	J.B. Lippincott & Co.	1st	English	281	A novel about innocence, justice, and racial prejudice in the American South.	2025-05-28 11:57:45.931578	2025-05-28 11:57:45.931578
3	1984	George Orwell	1949	978-0451524935	FIC ORW 1949	Secker & Warburg	1st	English	328	A dystopian novel set in a totalitarian society.	2025-05-28 11:57:45.931578	2025-05-28 11:57:45.931578
4	Cosmos	Carl Sagan	1980	978-0345539434	SCI SAG 1980	Random House	1st	English	384	An exploration of the universe and our place within it.	2025-05-28 11:57:45.931578	2025-05-28 11:57:45.931578
1	The Great Gatsby	F. Scott Fitzgerald	1926	978-0743273565	FIC FIT 1925	Charles Scribners Sons	1st	English	180	A story of wealth, love, and the American Dream in the Jazz Age.	2025-05-28 11:57:45.931578	2025-05-28 11:57:45.931578
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.categories (id, category_name, description, created_at, updated_at) FROM stdin;
2	Non-Fiction	Informational books based on facts, real events, and real people.	2025-05-28 11:57:45.935091	2025-05-28 11:57:45.935091
3	Science	Books related to scientific disciplines like physics, astronomy, biology.	2025-05-28 11:57:45.935091	2025-05-28 11:57:45.935091
4	History	Books detailing past events, societies, and civilizations.	2025-05-28 11:57:45.935091	2025-05-28 11:57:45.935091
1	Fiction	Narrative literary works whose content is produced by the imagination and story-telling.	2025-05-28 11:57:45.935091	2025-05-28 11:57:45.935091
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.inventory (id, book_id, aisle_id, shelf_number, row_number, copy_number, acquisition_date, condition, status, notes, created_at, updated_at) FROM stdin;
1	1	1	2	1	1	2020-01-15	Good	On Loan	\N	2025-05-28 11:57:45.936288	2025-05-28 11:57:45.936288
2	2	1	3	2	1	2020-02-20	New	On Loan	\N	2025-05-28 11:57:45.936288	2025-05-28 11:57:45.936288
3	3	2	1	1	1	2021-03-10	Fair	On Loan	\N	2025-05-28 11:57:45.936288	2025-05-28 11:57:45.936288
4	4	3	4	1	1	2021-05-05	Good	On Loan	\N	2025-05-28 11:57:45.936288	2025-05-28 11:57:45.936288
\.


--
-- Data for Name: library_users; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.library_users (id, first_name, last_name, email, phone_number, address, membership_id, join_date, status, created_at, updated_at) FROM stdin;
2	Bob	Builder	bob.builder@example.com	555-0102	456 Construction Rd	MEM002	2025-05-28	Active	2025-05-28 11:57:45.933455	2025-05-28 11:57:45.933455
3	Charlie	Chocolate	charlie.chocolate@example.com	555-0103	789 Factory Ln	MEM003	2025-05-28	Suspended	2025-05-28 11:57:45.933455	2025-05-28 11:57:45.933455
4	Diana	Prince	diana.prince@example.com	555-0104	101 Themyscira Way	MEM004	2025-05-28	Active	2025-05-28 11:57:45.933455	2025-05-28 11:57:45.933455
1	Alice	Wonder	alice.wonder@example.com	555-0199	123 Wonderland Ave	MEM001	2025-05-28	Active	2025-05-28 11:57:45.933455	2025-05-28 11:57:45.933455
\.


--
-- Data for Name: loans; Type: TABLE DATA; Schema: public; Owner: chepino
--

COPY public.loans (id, inventory_id, user_id, loan_date, due_date, return_date, status, fine_amount, notes, created_at, updated_at) FROM stdin;
1	1	1	2025-05-18	2025-06-01	\N	Active	0.00	\N	2025-05-28 11:57:45.944707	2025-05-28 11:57:45.944707
3	3	3	2025-05-23	2025-06-06	\N	Active	0.00	\N	2025-05-28 11:57:45.944707	2025-05-28 11:57:45.944707
2	2	2	2025-05-08	2025-05-22	2025-05-23	Returned	0.00	\N	2025-05-28 11:57:45.944707	2025-05-28 11:57:45.944707
4	4	4	2025-04-28	2025-05-26	\N	Overdue	5.00	User notified of overdue status.	2025-05-28 11:57:45.944707	2025-05-28 11:57:45.944707
\.


--
-- Name: aisles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.aisles_id_seq', 5, true);


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.books_id_seq', 5, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.categories_id_seq', 5, true);


--
-- Name: inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.inventory_id_seq', 5, true);


--
-- Name: library_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.library_users_id_seq', 5, true);


--
-- Name: loans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chepino
--

SELECT pg_catalog.setval('public.loans_id_seq', 5, true);


--
-- Name: aisle_categories aisle_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.aisle_categories
    ADD CONSTRAINT aisle_categories_pkey PRIMARY KEY (aisle_id, category_id);


--
-- Name: aisles aisles_aisle_number_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.aisles
    ADD CONSTRAINT aisles_aisle_number_key UNIQUE (aisle_number);


--
-- Name: aisles aisles_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.aisles
    ADD CONSTRAINT aisles_pkey PRIMARY KEY (id);


--
-- Name: book_categories book_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT book_categories_pkey PRIMARY KEY (book_id, category_id);


--
-- Name: books books_call_number_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_call_number_key UNIQUE (call_number);


--
-- Name: books books_isbn_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_isbn_key UNIQUE (isbn);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: categories categories_category_name_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_category_name_key UNIQUE (category_name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- Name: library_users library_users_email_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.library_users
    ADD CONSTRAINT library_users_email_key UNIQUE (email);


--
-- Name: library_users library_users_membership_id_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.library_users
    ADD CONSTRAINT library_users_membership_id_key UNIQUE (membership_id);


--
-- Name: library_users library_users_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.library_users
    ADD CONSTRAINT library_users_pkey PRIMARY KEY (id);


--
-- Name: loans loans_inventory_id_key; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_inventory_id_key UNIQUE (inventory_id);


--
-- Name: loans loans_pkey; Type: CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (id);


--
-- Name: idx_books_author; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_books_author ON public.books USING btree (author);


--
-- Name: idx_books_call_number; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_books_call_number ON public.books USING btree (call_number);


--
-- Name: idx_books_title; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_books_title ON public.books USING btree (title);


--
-- Name: idx_inventory_aisle_id; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_inventory_aisle_id ON public.inventory USING btree (aisle_id);


--
-- Name: idx_inventory_book_id; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_inventory_book_id ON public.inventory USING btree (book_id);


--
-- Name: idx_inventory_status; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_inventory_status ON public.inventory USING btree (status);


--
-- Name: idx_library_users_email; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_library_users_email ON public.library_users USING btree (email);


--
-- Name: idx_library_users_membership_id; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_library_users_membership_id ON public.library_users USING btree (membership_id);


--
-- Name: idx_loans_due_date; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_loans_due_date ON public.loans USING btree (due_date);


--
-- Name: idx_loans_inventory_id; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_loans_inventory_id ON public.loans USING btree (inventory_id);


--
-- Name: idx_loans_status; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_loans_status ON public.loans USING btree (status);


--
-- Name: idx_loans_user_id; Type: INDEX; Schema: public; Owner: chepino
--

CREATE INDEX idx_loans_user_id ON public.loans USING btree (user_id);


--
-- Name: aisle_categories fk_aisle_category_aisle; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.aisle_categories
    ADD CONSTRAINT fk_aisle_category_aisle FOREIGN KEY (aisle_id) REFERENCES public.aisles(id) ON DELETE CASCADE;


--
-- Name: aisle_categories fk_aisle_category_category; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.aisle_categories
    ADD CONSTRAINT fk_aisle_category_category FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: book_categories fk_book_category_book; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT fk_book_category_book FOREIGN KEY (book_id) REFERENCES public.books(id) ON DELETE CASCADE;


--
-- Name: book_categories fk_book_category_category; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT fk_book_category_category FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: inventory fk_inventory_aisle; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT fk_inventory_aisle FOREIGN KEY (aisle_id) REFERENCES public.aisles(id) ON DELETE SET NULL;


--
-- Name: inventory fk_inventory_book; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT fk_inventory_book FOREIGN KEY (book_id) REFERENCES public.books(id) ON DELETE CASCADE;


--
-- Name: loans fk_loan_inventory; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT fk_loan_inventory FOREIGN KEY (inventory_id) REFERENCES public.inventory(id) ON DELETE RESTRICT;


--
-- Name: loans fk_loan_user; Type: FK CONSTRAINT; Schema: public; Owner: chepino
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT fk_loan_user FOREIGN KEY (user_id) REFERENCES public.library_users(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

