-- Table: public.player_items

-- DROP TABLE IF EXISTS public.player_items;

CREATE TABLE IF NOT EXISTS public.player_items
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    player_id bigint NOT NULL,
    item_data_id integer NOT NULL,
    count bigint NOT NULL DEFAULT 0,
    grade integer NOT NULL DEFAULT 1,
    level integer NOT NULL DEFAULT 1,
    exp bigint NOT NULL DEFAULT 0,
    state_flag bigint NOT NULL DEFAULT 0,
    param1 integer NOT NULL DEFAULT 0,
    param2 integer NOT NULL DEFAULT 0,
    param3 integer NOT NULL DEFAULT 0,
    param4 integer NOT NULL DEFAULT 0,
    until_at timestamp with time zone,
    time_expiration_process_at timestamp with time zone,
    option json,
    deleted boolean NOT NULL DEFAULT false,
    CONSTRAINT player_items_pkey PRIMARY KEY (id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.player_items
    OWNER to idlez;

-- Index: player_id_deleted

CREATE INDEX IF NOT EXISTS player_id_deleted
    ON public.player_items USING btree
        (player_id ASC NULLS LAST, deleted ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: player_id_item_data_id

-- DROP INDEX IF EXISTS public.player_id_item_data_id;

CREATE INDEX IF NOT EXISTS player_id_item_data_id
    ON public.player_items USING btree
        (player_id ASC NULLS LAST, item_data_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: player_items_deleted_item_data_id_count_idx

-- DROP INDEX IF EXISTS public.player_items_deleted_item_data_id_count_idx;

CREATE INDEX IF NOT EXISTS player_items_deleted_item_data_id_count_idx
    ON public.player_items USING btree
        (deleted ASC NULLS LAST, item_data_id ASC NULLS LAST, count ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.player_items;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.player_items
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
