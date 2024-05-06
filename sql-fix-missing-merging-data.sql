

-- Here it's all the SQL code to fix the missing merging data, with the following codes, on studio edit, it show an error message and in the postgres server log (/var/lib/postgresql/data/pgdata/pg_log)
-- Here an example of error message:
-- postgresql-2024-05-06_161516.log:2024-05-06 16:19:13.810 UTC [624] ERROR:  insert or update on table "purchase_order" violates foreign key constraint "purchase_order_dest_address_id_fkey"
-- postgresql-2024-05-06_161516.log-2024-05-06 16:19:13.810 UTC [624] DETAIL:  Key (dest_address_id)=(3892) is not present in table "res_partner".

-- Model: res_partner_res_partner_category_rel (see error message below)
-- postgresql-2024-05-06_145332.log:2024-05-06 14:54:58.698 UTC [38] ERROR:  insert or update on table "res_partner_res_partner_category_rel" violates foreign key constraint "res_partner_res_partner_category_rel_partner_id_fkey"
-- postgresql-2024-05-06_145332.log-2024-05-06 14:54:58.698 UTC [38] DETAIL:  Key (partner_id)=(3464) is not present in table "res_partner".

DO
$$
DECLARE
    rel_row RECORD;
BEGIN
    FOR rel_row IN 
        SELECT * FROM res_partner_res_partner_category_rel
    LOOP
        IF NOT EXISTS (
            SELECT 1 
            FROM res_partner 
            WHERE id = rel_row.partner_id
        ) THEN
            DELETE FROM res_partner_res_partner_category_rel
            WHERE partner_id = rel_row.partner_id;
        END IF;
    END LOOP;
END
$$;


-- Model: res_partner (see error message below)
-- postgresql-2024-05-06_145332.log:2024-05-06 15:44:59.163 UTC [499] ERROR:  insert or update on table "res_partner" violates foreign key constraint "res_partner_x_studio_default_delivery_contact_fkey"
-- postgresql-2024-05-06_145332.log-2024-05-06 15:44:59.163 UTC [499] DETAIL:  Key (x_studio_default_delivery_contact)=(10278) is not present in table "res_partner".


DO
$$
DECLARE
    rel_row RECORD;
BEGIN
    FOR rel_row IN 
        SELECT * FROM res_partner
    LOOP
        IF NOT EXISTS (
            SELECT 1 
            FROM res_partner 
            WHERE id = rel_row.x_studio_default_delivery_contact
        ) THEN
            UPDATE res_partner SET x_studio_default_delivery_contact = NULL
            WHERE id = rel_row.id;
        END IF;
    END LOOP;
END
$$;


-- Model: crm_tag_rel (see error message below)
-- postgresql-2024-05-06_155001.log:2024-05-06 15:50:31.366 UTC [537] ERROR:  insert or update on table "crm_tag_rel" violates foreign key constraint "crm_tag_rel_lead_id_fkey"
-- postgresql-2024-05-06_155001.log-2024-05-06 15:50:31.366 UTC [537] DETAIL:  Key (lead_id)=(1660) is not present in table "crm_lead".


DO
$$
DECLARE
    rel_row RECORD;
BEGIN
    FOR rel_row IN 
        SELECT * FROM crm_tag_rel
    LOOP
        IF NOT EXISTS (
            SELECT 1 
            FROM crm_lead 
            WHERE id = rel_row.lead_id
        ) THEN
            DELETE FROM crm_tag_rel
            WHERE lead_id = rel_row.lead_id;
        END IF;
    END LOOP;
END
$$;



-- Model: product_variant_combination (see error message below)
-- postgresql-2024-05-06_155001.log:2024-05-06 15:59:08.005 UTC [533] ERROR:  insert or update on table "product_variant_combination" violates foreign key constraint "product_variant_combination_product_product_id_fkey"
-- postgresql-2024-05-06_155001.log-2024-05-06 15:59:08.005 UTC [533] DETAIL:  Key (product_product_id)=(579) is not present in table "product_product".


DO
$$
DECLARE
    rel_row RECORD;
BEGIN
    FOR rel_row IN 
        SELECT * FROM product_variant_combination
    LOOP
        IF NOT EXISTS (
            SELECT 1 
            FROM product_product 
            WHERE id = rel_row.product_product_id
        ) THEN
            DELETE FROM product_variant_combination
            WHERE product_product_id = rel_row.product_product_id;
        END IF;
    END LOOP;
END
$$;

-- Model: project_task_user_rel (see error message below)
-- postgresql-2024-05-06_155001.log:2024-05-06 16:04:58.343 UTC [549] ERROR:  insert or update on table "project_task_user_rel" violates foreign key constraint "project_task_user_rel_task_id_fkey"
-- postgresql-2024-05-06_155001.log-2024-05-06 16:04:58.343 UTC [549] DETAIL:  Key (task_id)=(1488) is not present in table "project_task".

DO
$$
DECLARE
    rel_row RECORD;
BEGIN
    FOR rel_row IN 
        SELECT * FROM project_task_user_rel
    LOOP
        IF NOT EXISTS (
            SELECT 1 
            FROM project_task 
            WHERE id = rel_row.task_id
        ) THEN
            DELETE FROM project_task_user_rel
            WHERE task_id = rel_row.task_id;
        END IF;
    END LOOP;
END
$$;

-- Model: project_task (see error message below)
-- postgresql-2024-05-06_155001.log:2024-05-06 16:08:47.561 UTC [549] ERROR:  insert or update on table "project_task" violates foreign key constraint "project_task_helpdesk_ticket_id_fkey"
-- postgresql-2024-05-06_155001.log-2024-05-06 16:08:47.561 UTC [549] DETAIL:  Key (helpdesk_ticket_id)=(101) is not present in table "helpdesk_ticket".


DO
$$
DECLARE
    rel_row RECORD;
BEGIN
    FOR rel_row IN 
        SELECT * FROM project_task
    LOOP
        IF NOT EXISTS (
            SELECT 1 
            FROM helpdesk_ticket 
            WHERE id = rel_row.helpdesk_ticket_id
        ) THEN
            UPDATE project_task SET helpdesk_ticket_id = NULL
            WHERE id = rel_row.id;
        END IF;
    END LOOP;
END
$$;

-- Model: helpdesk_tag_helpdesk_ticket_rel (see error message below)
-- postgresql-2024-05-06_161516.log:2024-05-06 16:17:16.321 UTC [624] ERROR:  insert or update on table "helpdesk_tag_helpdesk_ticket_rel" violates foreign key constraint "helpdesk_tag_helpdesk_ticket_rel_helpdesk_ticket_id_fkey"
-- postgresql-2024-05-06_161516.log-2024-05-06 16:17:16.321 UTC [624] DETAIL:  Key (helpdesk_ticket_id)=(688) is not present in table "helpdesk_ticket".

DO
$$
DECLARE
    rel_row RECORD;
BEGIN
    FOR rel_row IN 
        SELECT * FROM helpdesk_tag_helpdesk_ticket_rel
    LOOP
        IF NOT EXISTS (
            SELECT 1 
            FROM helpdesk_ticket 
            WHERE id = rel_row.helpdesk_ticket_id
        ) THEN
            DELETE FROM helpdesk_tag_helpdesk_ticket_rel
            WHERE helpdesk_ticket_id = rel_row.helpdesk_ticket_id;
        END IF;
    END LOOP;
END
$$;

-- Model: purchase_order (see error message below)
-- postgresql-2024-05-06_161516.log:2024-05-06 16:19:13.810 UTC [624] ERROR:  insert or update on table "purchase_order" violates foreign key constraint "purchase_order_dest_address_id_fkey"
-- postgresql-2024-05-06_161516.log-2024-05-06 16:19:13.810 UTC [624] DETAIL:  Key (dest_address_id)=(3892) is not present in table "res_partner".


DO
$$
DECLARE
    rel_row RECORD;
BEGIN
    FOR rel_row IN 
        SELECT * FROM purchase_order
    LOOP
        IF NOT EXISTS (
            SELECT 1 
            FROM res_partner 
            WHERE id = rel_row.dest_address_id
        ) THEN
            UPDATE purchase_order SET dest_address_id = NULL
            WHERE id = rel_row.id;
        END IF;
    END LOOP;
END
$$;


-- Model: ir_model_data (this command is different from the others, see error message below)
-- psycopg2.errors.InvalidColumnReference: there is no unique or exclusion constraint matching the ON CONFLICT specification

ALTER TABLE ir_model_data
ADD CONSTRAINT unique_module_name UNIQUE (module, name);