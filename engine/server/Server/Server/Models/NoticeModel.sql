-- Table: public.notices

-- DROP TABLE IF EXISTS public.notices;

CREATE TABLE IF NOT EXISTS public.notices
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "order" integer NOT NULL DEFAULT 0,
    type integer NOT NULL DEFAULT 0,
    start_at timestamp with time zone,
    until_at timestamp with time zone,
    language character varying(32) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    title character varying(256) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    message text COLLATE pg_catalog."default",
    image_url character varying(2048) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    image_path character varying(2048) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    CONSTRAINT notices_pkey PRIMARY KEY (id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.notices
    OWNER to idlez;

-- Index: notices_visible_order_idx

-- DROP INDEX IF EXISTS public.notices_visible_order_idx;

CREATE INDEX IF NOT EXISTS notices_visible_order_idx
    ON public.notices USING btree
    (start_at ASC NULLS LAST, until_at ASC NULLS LAST, "order" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.notices;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.notices
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
