-- Table: public.players

-- DROP TABLE IF EXISTS public.players;

CREATE TABLE IF NOT EXISTS public.players
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_id bigint NOT NULL DEFAULT 0,
    world_id bigint NOT NULL DEFAULT 1,
    name character varying(128) COLLATE pg_catalog."default" NOT NULL,
    language character varying(32) COLLATE pg_catalog."default" NOT NULL DEFAULT 'English'::character varying,
    is_admin boolean NOT NULL DEFAULT false,
    level integer NOT NULL DEFAULT 1,
    power bigint NOT NULL DEFAULT 0,
    avatar_character_item_data_id integer NOT NULL DEFAULT 0,
    day_reset_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT id_pkey PRIMARY KEY (id),
    CONSTRAINT players_name_unique UNIQUE (name)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.players
    OWNER to idlez;

-- Index: players_account_id_idx

-- DROP INDEX IF EXISTS public.players_account_id_idx;

CREATE INDEX IF NOT EXISTS players_account_id_idx
    ON public.players USING btree
    (account_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Index: players_day_reset_at_idx

-- DROP INDEX IF EXISTS public.players_day_reset_at_idx;

CREATE INDEX IF NOT EXISTS players_day_reset_at_idx
    ON public.players USING btree
    (day_reset_at ASC NULLS LAST)
    TABLESPACE pg_default;

-- Index: players_created_at_idx

-- DROP INDEX IF EXISTS public.players_created_at_idx;

CREATE INDEX IF NOT EXISTS players_created_at_idx
    ON public.players USING btree
    (created_at ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: players_updated_at_idx

-- DROP INDEX IF EXISTS public.players_updated_at_idx;

CREATE INDEX IF NOT EXISTS players_updated_at_idx
    ON public.players USING btree
    (updated_at ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.players;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
                      ON public.players
                      FOR EACH ROW
                      EXECUTE FUNCTION public.update_updated_at();
