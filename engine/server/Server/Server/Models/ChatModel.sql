-- Table: public.chats

-- DROP TABLE IF EXISTS public.chats;

CREATE TABLE IF NOT EXISTS public.chats
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    type integer NOT NULL DEFAULT 0,
    channel_key character varying(128) COLLATE pg_catalog."default" NOT NULL,
    sender_player_id bigint NOT NULL DEFAULT 0,
    language character varying(32) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    title character varying(256) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    message text COLLATE pg_catalog."default",
    CONSTRAINT chats_pkey PRIMARY KEY (id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.chats
    OWNER to idlez;

-- Index: chats_channel_key_id_idx

-- DROP INDEX IF EXISTS public.chats_channel_key_id_idx;

CREATE INDEX IF NOT EXISTS chats_channel_key_id_idx
    ON public.chats USING btree
    (channel_key ASC NULLS LAST, id DESC NULLS FIRST)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.chats;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.chats
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
