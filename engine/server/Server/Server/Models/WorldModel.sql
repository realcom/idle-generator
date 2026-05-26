-- Table: public.worlds

-- DROP TABLE IF EXISTS public.worlds;

CREATE TABLE IF NOT EXISTS public.worlds
(
    id bigint NOT NULL,
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    region integer NOT NULL DEFAULT 0,
    region_index integer NOT NULL,
    state integer NOT NULL DEFAULT 1,
    utc_offset_hours integer NOT NULL DEFAULT 0,
    CONSTRAINT worlds_pkey PRIMARY KEY (id),
    CONSTRAINT worlds_region_region_index_unique UNIQUE (region, region_index)
)

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.worlds
    OWNER to idlez;

-- Trigger: update_updated_at

-- DROP TRIGGER IF EXISTS update_updated_at ON public.worlds;

CREATE OR REPLACE TRIGGER update_updated_at
    BEFORE UPDATE
    ON public.worlds
    FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at();

INSERT INTO public.worlds (id, region, region_index, state, utc_offset_hours)
VALUES (1, 0, 1, 1, 0)
ON CONFLICT (id) DO UPDATE
SET region = EXCLUDED.region,
    region_index = EXCLUDED.region_index,
    state = EXCLUDED.state,
    utc_offset_hours = EXCLUDED.utc_offset_hours;
