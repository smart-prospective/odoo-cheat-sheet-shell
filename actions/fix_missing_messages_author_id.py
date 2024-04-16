# In the Message model (mail.message) :

for record in records:
    if record.author_id:
        partner_record = env['res.partner'].search([('id', '=', record.author_id.id)])
        if not partner_record:
            # find similar partner
            record.write({'author_id':False})

