-- Table: public.accounts

-- DROP TABLE IF EXISTS public.accounts;

CREATE TABLE IF NOT EXISTS public.accounts
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
        INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1
    ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sns_id character varying(128) COLLATE pg_catalog."default" NOT NULL,
    name character varying(128) COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    language character varying(32) COLLATE pg_catalog."default" NOT NULL DEFAULT 'English'::character varying,
    is_admin boolean NOT NULL DEFAULT false,
    state integer NOT NULL DEFAULT 1,
    play_game_id character varying(128) COLLATE pg_catalog."default",
    game_center_id character varying(128) COLLATE pg_catalog."default",
    device_id character varying(128) COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    device_os character varying(32) COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    device_model character varying(64) COLLATE pg_catalog."default",
    push_token character varying(128) COLLATE pg_catalog."default",
    main_player_id bigint NOT NULL DEFAULT 0,
    country character varying(16) COLLATE pg_catalog."default",
    CONSTRAINT accounts_pkey PRIMARY KEY (id),
    CONSTRAINT accounts_sns_id_unique UNIQUE (sns_id)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.accounts
    OWNER to idlez;

CREATE INDEX IF NOT EXISTS accounts_main_player_id_idx
    ON public.accounts USING btree
    (main_player_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.accounts;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.accounts
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
