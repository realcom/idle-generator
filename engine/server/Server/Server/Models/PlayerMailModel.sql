-- Table: public.player_mails

-- DROP TABLE IF EXISTS public.player_mails;

CREATE TABLE IF NOT EXISTS public.player_mails
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    player_id bigint NOT NULL,
    sender_player_id bigint NOT NULL DEFAULT 0,
    until_at timestamp with time zone,
    title character varying(256) COLLATE pg_catalog."default" NOT NULL,
    message text COLLATE pg_catalog."default",
    item_data_id integer NOT NULL,
    item_count bigint NOT NULL,
    item_level integer NOT NULL DEFAULT 0,
    item_days integer NOT NULL DEFAULT 0,
    item_hours integer NOT NULL DEFAULT 0,
    item_option json,
    option json,
    read_at timestamp with time zone,
    deleted boolean NOT NULL DEFAULT false,
    CONSTRAINT player_mails_pkey PRIMARY KEY (id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.player_mails
    OWNER to idlez;
-- Index: player_mails_player_id_read_at_idx

-- DROP INDEX IF EXISTS public.player_mails_player_id_read_at_idx;

CREATE INDEX IF NOT EXISTS player_mails_player_id_read_at_idx
    ON public.player_mails USING btree
    (player_id ASC NULLS LAST, read_at ASC NULLS LAST, deleted ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.player_mails;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.player_mails
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
