-- Table: public.player_achievements

-- DROP TABLE IF EXISTS public.player_achievements;

CREATE TABLE IF NOT EXISTS public.player_achievements
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    player_id bigint NOT NULL,
    achievement_data_id integer NOT NULL,
    state integer NOT NULL DEFAULT 0,
    progress integer NOT NULL DEFAULT 0,
    CONSTRAINT player_achievements_pkey PRIMARY KEY (id),
    CONSTRAINT player_achievements_player_id_achievement_data_id_key UNIQUE (player_id, achievement_data_id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.player_achievements
    OWNER to idlez;
-- Index: achievement_data_id_state

-- DROP INDEX IF EXISTS public.achievement_data_id_state;

CREATE INDEX IF NOT EXISTS achievement_data_id_state
    ON public.player_achievements USING btree
        (achievement_data_id ASC NULLS LAST, state ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.player_achievements;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.player_achievements
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
