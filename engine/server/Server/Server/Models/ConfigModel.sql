-- Table: public.configs

-- DROP TABLE IF EXISTS public.configs;

CREATE TABLE IF NOT EXISTS public.configs
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    key character varying(256) COLLATE pg_catalog."default" NOT NULL,
    value_bool boolean,
    value_int integer,
    value_float real,
    value_string character varying(1024) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    value_datetime timestamp with time zone,
    CONSTRAINT configs_pkey PRIMARY KEY (id),
    CONSTRAINT configs_key_key UNIQUE (key)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.configs
    OWNER to idlez;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.configs;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.configs
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
