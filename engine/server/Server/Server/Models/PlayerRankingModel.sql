-- Table: public.player_rankings

-- DROP TABLE IF EXISTS public.player_rankings;

CREATE TABLE IF NOT EXISTS public.player_rankings
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    player_id bigint NOT NULL,
    ranking_id integer NOT NULL,
    date integer NOT NULL,
    score bigint NOT NULL,
    valid boolean NOT NULL DEFAULT true,
    CONSTRAINT player_rankings_pkey PRIMARY KEY (id),
    CONSTRAINT player_rankings_player_id_ranking_id_date_key UNIQUE (player_id, ranking_id, date)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.player_rankings
    OWNER to idlez;
-- Index: ranking_id_date_score

-- DROP INDEX IF EXISTS public.ranking_id_date_score;

CREATE INDEX IF NOT EXISTS ranking_id_date_score
    ON public.player_rankings USING btree
        (ranking_id ASC NULLS LAST, date ASC NULLS LAST, score DESC NULLS LAST)
    TABLESPACE pg_default;
-- Index: valid_ranking_id_date_score

-- DROP INDEX IF EXISTS public.valid_ranking_id_date_score;

CREATE INDEX IF NOT EXISTS valid_ranking_id_date_score
    ON public.player_rankings USING btree
        (valid ASC NULLS LAST, ranking_id ASC NULLS LAST, date ASC NULLS LAST, score DESC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.player_rankings;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.player_rankings
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
