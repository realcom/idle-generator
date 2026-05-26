-- Table: public.player_telegrams

-- DROP TABLE IF EXISTS public.player_telegrams;

CREATE TABLE IF NOT EXISTS public.player_telegrams
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    telegram_user_id bigint NOT NULL,
    first_name character varying(128) COLLATE pg_catalog."default" NOT NULL,
    last_name character varying(128) COLLATE pg_catalog."default",
    username character varying(32) COLLATE pg_catalog."default",
    is_bot boolean NOT NULL,
    is_premium boolean NOT NULL,
    is_admin boolean NOT NULL DEFAULT false,
    is_analyst boolean NOT NULL DEFAULT false,
    ton_address character varying(48) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    CONSTRAINT player_telegrams_pkey PRIMARY KEY (id),
    CONSTRAINT player_telegrams_telegram_user_id_key UNIQUE (telegram_user_id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.player_telegrams
    OWNER to idlez;
-- Index: player_telegrams_created_at_idx

-- DROP INDEX IF EXISTS public.player_telegrams_created_at_idx;

CREATE INDEX IF NOT EXISTS player_telegrams_created_at_idx
    ON public.player_telegrams USING btree
        (created_at ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: player_telegrams_updated_at_idx

-- DROP INDEX IF EXISTS public.player_telegrams_updated_at_idx;

CREATE INDEX IF NOT EXISTS player_telegrams_updated_at_idx
    ON public.player_telegrams USING btree
        (updated_at ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.player_telegrams;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.player_telegrams
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
