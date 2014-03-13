Aobotracker::Application.config.privileges = {}

Aobotracker::Application.config.privileges[:delete_expense_type] = ['manager']
Aobotracker::Application.config.privileges[:set_expense_status] = ['manager']
Aobotracker::Application.config.privileges[:modify_expense] = ['manager']
Aobotracker::Application.config.privileges[:request_expense_reimbursement] = ['employee','manager']
