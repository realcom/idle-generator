-- Table: public.player_pushes

-- DROP TABLE IF EXISTS public.player_pushes;

CREATE TABLE IF NOT EXISTS public.player_pushes
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    type integer NOT NULL DEFAULT 0,
    player_id bigint NOT NULL,
    publish_at timestamp with time zone,
    published boolean NOT NULL DEFAULT false,
    failed boolean NOT NULL DEFAULT false,
    retry_count integer NOT NULL DEFAULT 0,
    deleted boolean NOT NULL DEFAULT false,
    language character varying(32) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    title character varying(256) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    message text COLLATE pg_catalog."default",
    image_url character varying(2048) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    key character varying(128) COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    CONSTRAINT player_pushes_pkey PRIMARY KEY (id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.player_pushes
    OWNER to idlez;
-- Index: player_pushes_player_id_type_published_deleted_idx

-- DROP INDEX IF EXISTS public.player_pushes_player_id_type_published_deleted_idx;

CREATE INDEX IF NOT EXISTS player_pushes_player_id_type_published_deleted_idx
    ON public.player_pushes USING btree
        (player_id ASC NULLS LAST, type ASC NULLS LAST, published ASC NULLS LAST, deleted ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: player_pushes_published_deleted_failed_publish_at_idx

-- DROP INDEX IF EXISTS public.player_pushes_published_deleted_failed_publish_at_idx;

CREATE INDEX IF NOT EXISTS player_pushes_published_deleted_failed_publish_at_idx
    ON public.player_pushes USING btree
        (published ASC NULLS LAST, deleted ASC NULLS LAST, failed ASC NULLS LAST, publish_at ASC NULLS FIRST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;

-- Index: player_pushes_player_id_key_published_idx

-- DROP INDEX IF EXISTS public.player_pushes_player_id_key_published_idx;

CREATE INDEX IF NOT EXISTS player_pushes_player_id_key_published_idx
    ON public.player_pushes USING btree
        (player_id ASC NULLS LAST, key ASC NULLS LAST, published ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.player_pushes;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.player_pushes
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
