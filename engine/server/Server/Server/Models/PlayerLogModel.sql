-- Table: public.player_logs

-- DROP TABLE IF EXISTS public.player_logs;

CREATE TABLE IF NOT EXISTS public.player_logs
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    player_id bigint NOT NULL,
    type integer NOT NULL,
    data json NOT NULL DEFAULT '{}'::json,
    CONSTRAINT player_logs_pkey PRIMARY KEY (id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.player_logs
    OWNER to idlez;
-- Index: player_id_created_at

-- DROP INDEX IF EXISTS public.player_id_created_at;

CREATE INDEX IF NOT EXISTS player_id_created_at
    ON public.player_logs USING btree
        (player_id ASC NULLS LAST, created_at DESC NULLS FIRST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: player_logs_player_id_type_created_at_idx

-- DROP INDEX IF EXISTS public.player_logs_player_id_type_created_at_idx;

CREATE INDEX IF NOT EXISTS player_logs_player_id_type_created_at_idx
    ON public.player_logs USING btree
        (player_id ASC NULLS LAST, type ASC NULLS LAST, created_at ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: type_created_at

-- DROP INDEX IF EXISTS public.type_created_at;

CREATE INDEX IF NOT EXISTS type_created_at
    ON public.player_logs USING btree
        (type ASC NULLS LAST, created_at ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.player_logs;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.player_logs
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
