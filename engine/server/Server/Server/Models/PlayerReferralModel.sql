-- Table: public.player_referrals

-- DROP TABLE IF EXISTS public.player_referrals;

CREATE TABLE IF NOT EXISTS public.player_referrals
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    referred_player_id bigint NOT NULL,
    referrer_player_id bigint NOT NULL,
    applied boolean NOT NULL,
    CONSTRAINT player_referrals_pkey PRIMARY KEY (id),
    CONSTRAINT player_referrals_referrer_player_id_key UNIQUE (referrer_player_id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.player_referrals
    OWNER to idlez;
-- Index: player_referrals_created_at_idx

-- DROP INDEX IF EXISTS public.player_referrals_created_at_idx;

CREATE INDEX IF NOT EXISTS player_referrals_created_at_idx
    ON public.player_referrals USING btree
        (created_at ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: player_referrals_referred_player_id_applied_idx

-- DROP INDEX IF EXISTS public.player_referrals_referred_player_id_applied_idx;

CREATE INDEX IF NOT EXISTS player_referrals_referred_player_id_applied_idx
    ON public.player_referrals USING btree
        (referred_player_id ASC NULLS LAST, applied ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.player_referrals;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.player_referrals
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
