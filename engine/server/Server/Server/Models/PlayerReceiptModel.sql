-- Table: public.player_receipts

-- DROP TABLE IF EXISTS public.player_receipts;

CREATE TABLE IF NOT EXISTS public.player_receipts
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    uuid uuid NOT NULL,
    player_id bigint NOT NULL,
    product_item_data_id integer NOT NULL,
    valid_until timestamp with time zone NOT NULL,
    paid boolean NOT NULL DEFAULT false,
    applied boolean NOT NULL DEFAULT false,
    restored boolean NOT NULL DEFAULT false,
    restored_at timestamp with time zone,
    data text COLLATE pg_catalog."default" NOT NULL DEFAULT ''::text,
    order_id character varying(256) COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    purchase_token character varying(512) COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    price real NOT NULL,
    currency character varying(8) COLLATE pg_catalog."default" NOT NULL,
    telegram_invoice_link character varying(2048) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    CONSTRAINT player_receipts_pkey PRIMARY KEY (id),
    CONSTRAINT player_receipts_uuid_key UNIQUE (uuid)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.player_receipts
    OWNER to idlez;
-- Index: player_receipts_created_at_idx

-- DROP INDEX IF EXISTS public.player_receipts_created_at_idx;

CREATE INDEX IF NOT EXISTS player_receipts_created_at_idx
    ON public.player_receipts USING btree
        (created_at ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: player_receipts_player_id_applied_paid_idx

-- DROP INDEX IF EXISTS public.player_receipts_player_id_applied_paid_idx;

CREATE INDEX IF NOT EXISTS player_receipts_player_id_applied_paid_idx
    ON public.player_receipts USING btree
        (player_id ASC NULLS LAST, applied ASC NULLS LAST, paid ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: player_receipts_player_id_product_item_data_id_valid_until_idx

-- DROP INDEX IF EXISTS public.player_receipts_player_id_product_item_data_id_valid_until_idx;

CREATE INDEX IF NOT EXISTS player_receipts_player_id_product_item_data_id_valid_until_idx
    ON public.player_receipts USING btree
        (player_id ASC NULLS LAST, product_item_data_id ASC NULLS LAST, valid_until ASC NULLS LAST)
    WITH (deduplicate_items=True)
    TABLESPACE pg_default;

-- Index: player_receipts_order_id_idx

-- DROP INDEX IF EXISTS public.player_receipts_order_id_idx;

CREATE INDEX IF NOT EXISTS player_receipts_order_id_idx
    ON public.player_receipts USING btree
        (order_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.player_receipts;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.player_receipts
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();
