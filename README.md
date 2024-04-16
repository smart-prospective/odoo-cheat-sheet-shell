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

Quick Start in Shell
--------------------
```python
# Get the company of your contact (the orginal one created)
contact = env["res.partner"].search([('id', '=', 1)])
print(contact.name)
# Get the 1st contact link to it (you?)
me = contact.child_ids[0]
print(me.name)
# Sorry if it fail, you probably don't use the same logic in you contact as us (Contact > Contact.parent_id is the Company)
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

To perform a serach/query with multiple parameters (such as AND or OR):
```python
# Here a request with an AND
env['product.attribute.value'].search(["&", ('name', '=', 'NC'), ('attribute_id', '=', attribute.id)], limit=1)
# Here a request with an OR
env['product.attribute.value'].search(["|", ('name', '=', 'NC'), ('attribute_id', '=', attribute.id)], limit=1)

```

Create a Record
---------------

To create an instance of an object (called "record"):
```python
# Create a contact
env['res.partner'].create({"name": 'New Contact Name'})
# Create a document request
env['documents.document'].create({"name": "Document Name"})
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

Usefull Method
--------------

Few methods are really usefull to know and simple to use (just need to be aware of them ^^)
```python
# Add a note/message in the record and if you specify partner_ids (optionnal) (list of res.partner id) it will notify them.
record.message_post(body=f"The action X has been applied here...", partner_ids=[user.id])

# Log a message in the server (You can can find them in Odoo > Parameters > Technical (Need Developper Mode Enabled) > Logging
log(f"This is a log about X", level='info')

# Send a mail from a template (need a record, which will be used as the 'object' variable in the mail template)
mail_template = self.env['mail.template'].search([('id', '=', 53)])
mail_template.send_mail(record.id)

# Set Datetime to Now
record.write({"date_end": datetime.datetime.now()})
```

Usefull Fields
--------------

Few fields are not so difficult to find but only if you know where to look for.
If you are curious, or just don't find what you look for in the following list go to: Odoo > Parameters > Technical (Need Developper Mode Enabled) > Fields > Search for what you want using filters
```python
# Get parent of a contact
contact_parent = record.parent_id

# Get Followers of a record (such as contact):
followers = record.message_partner_ids

# The current user who do the update of a record. Can be used in an action
log(f"The user {env.user.name} just trigger the action: X", level='info')
```

Usefull Model
```python
products = env['product.template'].search([])  # All Products
internal_users = env['res.users'].search([])  # All Internal User (The one invited, paid profile)

```

Miscellaneous
-------------

To add a dynamic link into a mail template (such as a link to a contact form). Create your button, then edit in code mode (via the language for example) and change the href in t-att-href, then write python code into it.
```QWeb
<a t-att-href="'/web#id=' + str(object.id) + '&amp;cids=1&amp;menu_id=233&amp;action=346&amp;model=res.partner&amp;view_type=form'" style="color:#008f8c;text-decoration: none; box-sizing: border-box;">Link to edit your contact</a>
```
To open a new tab with an url (computed or not) in an action
```python
# In this example we compute the url of a contact and on the action execution (via a <button name="ID_OF_THIS_ACTION">) we open the form view of the contact
base_url = env['ir.config_parameter'].get_param('web.base.url')
record_url = base_url + '/web#id=' + str(record.id) + '&view_type=form&model=' + str(model._name) + '&menu_id=436'

action = {
    'type': 'ir.actions.act_url',
    'target': 'new',
    'url': record_url,
}
```
-------------

To enable the viewing of the files all the time from the messages section, the file "/odoo/odoo/addons/mail/static/src/core/web/chatter.js" has to be modified:
on line 190 : remove the "isAttachmentBoxVisibleInitially", the section should look like this :
```javascript
    this.state.isAttachmentBoxOpened = this.attachments.length > 0;
}
```
on line 100 : replace the values of "isAttachmentBoxOpened", the value should be set to "true"

-------------
To remove the "Généré par Odoo" expression from mails, you should start by search for "`<!-- POWERED BY -->`" expression in your odoo code, sort on the .xml files, you should have all the files that will need to be changed on the platform.
Open Odoo, than open "Vues" and "Email Templates" accessible from "Technical":
You should now start matching each reference from the code to it's version on the server, here is an example :

```xml
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <data noupdate="1">
        <!-- Email template for new users -->
        <record id="set_password_email" model="mail.template">
            <field name="name">Settings: New Portal Signup</field>
            <field name="model_id" ref="base.model_res_users"/>
            <field name="subject">{{ object.create_uid.name }} from {{ object.company_id.name }} invites you to connect to Odoo</field>
                                                    ......
                                                    ......
                                                    ......
</tbody>
</table>
</td></tr>
<!-- POWERED BY -->
<tr><td align="center" style="min-width: 590px;">
    <table border="0" cellpadding="0" cellspacing="0" width="590" style="min-width: 590px; background-color: #F1F1F1; color: #454748; padding: 8px; border-collapse:separate;">
      <tr><td style="text-align: center; font-size: 13px;">
        Powered by <a target="_blank" href="https://www.odoo.com?utm_source=db&amp;utm_medium=auth" style="color: #875A7B;">Odoo</a>
      </td></tr>
    </table>
</td></tr>
```
In this example, the file is located in "data" sub directory, and the "model" is a "mail.template", so we have to find it in email templates and edit it.
If instead you find the subdirectory to have views, and instead of model you only have "`<template id="xxxxxx" name="xxxxx">`" than you will need to search in vues using the "name" to find the view.

And now remove the section starting by "`<!-- POWERED BY -->`" to "`</td></tr>`", sometimes you only need to remove only line of xml, each case is different.

Server Actions
--------------
The following actions solves various problems via code (some are linked to Contextual Action / Some are linked to Automations)

For the contextual: You need to select the instances (list view) and select in the "action" the 

* When in the chat part of a recording, there is a bug of "messages not loading" in Odoo, when it's caused by a "Record missing or deleted" in a "mail.message", create the following server action in the model: "Message (mail.message)" (Contextual) :
```python
# Fix by removing the author_id when not existing anymore in the mail.message
for record in records:
    if record.author_id:
        partner_record = env['res.partner'].search([('id', '=', record.author_id.id)])
        if not partner_record:
            # find similar partner
            record.write({'author_id':False})
```


