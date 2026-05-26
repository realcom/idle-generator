-- Table: public.player_avatars

-- DROP TABLE IF EXISTS public.player_avatars;

CREATE TABLE IF NOT EXISTS public.player_avatars
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    player_id bigint NOT NULL,
    data json NOT NULL DEFAULT '{}'::json,
    CONSTRAINT player_avatars_pkey PRIMARY KEY (id),
    CONSTRAINT player_avatars_player_id_key UNIQUE (player_id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.player_avatars
    OWNER to idlez;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.player_avatars;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.player_avatars
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
