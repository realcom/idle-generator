-- Table: public.board_histories

-- DROP TABLE IF EXISTS public.board_histories;

CREATE TABLE IF NOT EXISTS public.board_histories
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    board bytea,
    events json NOT NULL DEFAULT '[]'::json,
    player_ids bigint[] NOT NULL DEFAULT ARRAY[]::bigint[],
    summary json DEFAULT '{}'::json,
    CONSTRAINT board_histories_pkey PRIMARY KEY (id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.board_histories
    OWNER to idlez;
-- Index: player_ids_id

-- DROP INDEX IF EXISTS public.player_ids_id;

CREATE INDEX IF NOT EXISTS player_ids_id
    ON public.board_histories USING btree
    (player_ids ASC NULLS LAST, id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.board_histories;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
                      ON public.board_histories
                      FOR EACH ROW
                      EXECUTE FUNCTION public.update_updated_at();
