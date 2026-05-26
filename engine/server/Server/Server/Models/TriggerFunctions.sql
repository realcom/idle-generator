-- FUNCTION: public.update_updated_at()

-- DROP FUNCTION IF EXISTS public.update_updated_at();

CREATE OR REPLACE FUNCTION public.update_updated_at()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.update_updated_at()
    OWNER TO idlez;
