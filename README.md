# odoo-cheat-sheet-shell
Odoo Cheat Sheet for Shell, Action, Modules


Goal of the document
--------------------

This Cheat Sheet, is to help anyone who want to test its code (for a Server Action or even for a custom Module for example). It's for the community.


How to
------

To run the shell in a terminal, you need to use another Port (if your server is already running)

Direct:
```bash
python3 odoo-bin shell -p 4242 -d odoo-db --addons-path "./extra-addons"
```

Via Docker:
```bash
docker exec -it odoo python3 odoo-bin shell -p 4242 -d odoo-db --addons-path "/mnt/extra-addons"
```

By default, the shell is running in transaction mode. This means that any change made to the database is rolled back when exiting the shell.
To commit changes, use:
```python
env.cr.commit()
```

Get Instances & Values
----------------------

Get the instances of a model (no filter = all) (e.g. 'res.partner' called "Contact")
```python
# Get all existing contacts
contacts = env["res.partner"].search([])

# Loop through the contacts as records (such as in Server Action)
for record in contacts:
    print(record)
```

Get Category called "Tag" (e.g. 'res.partner.category' called "Contact Category"
```python
tag_name = "Client"
tag = env['res.partner.category'].search([('name', '=', tag_name)], limit=1)
if not tag:
  raise UserError("Tag '%s' not found. Please make sure the tag exists." % tag_name)
```

Edit Data & Fields
------------------

Edit a simple field (e.g.: record is a Contact & x_studio_frist_name is a new field created via Odoo Studio)
```python
record.write({'x_studio_first_name': record.name.split(" ")[0]})
```

Set a M2M (many to many) by adding an instance
```python
tag_name = "Client"
tag = env['res.partner.category'].search([('name', '=', tag_name)], limit=1)
# 4: is the code to add an instance in M2M
record.write({'category_id': [(4, tag.id)]})
```

Remove Data
-----------

Edit a M2M (many to many) by removing an instance from a M2M field such as Category
```python
tag_name = "Client"
tag = env['res.partner.category'].search([('name', '=', tag_name)], limit=1)
# 3: is the code to delete an instance in M2M
record.write({'category_id': [(3, tag.id)]})
```
