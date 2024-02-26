export const resources_param_config = {
    resources: {
        invoices: {
            actions: {
                all: {
                    mutually_exclusive: [put, post, get]
                },
                put: {
                    update: {
                        required: [id, body]
                    },
                    create: {
                        required: [body]
                        }
                },
                post: {
                    create: {
                        required: [body],
                        mutually_exclusive: [id]
                    }
                },
                get: {
                    mutually_exclusive: [body]
                }
            },
            args: {
                all: {
                    mutually_exclusive: {
                        actions: [put, post]
                    }
                },
                from-date: {
                    completion: [now]
                    mutually_exclusive: [from, date]
                },
                to-date: {
                    expects: {
                        any_one: [from, date, for-year, for-quarter, for-month, for-day]
                    }
                }
                from: {
                    completion: ['12 days ago', '1 month ago', '1 year ago']
                    expects: {
                        any_one: [from, date, for-year, for-quarter, for-month, for-day]
                    }
                }
                raw: {
                    mutually_exclusive: [brief, obfuscate]
                }
                brief: {
                    mutually_exclusive: [obfuscate, raw]
                }
                obfuscate: {
                    mutually_exclusive: [brief, raw]
                }
            },
            filter: [unbooked, cancelled, fullypaid, unpaid, unpaidoverdue]
            sort-by: [ascending descending]
        }
        invoicepayments: {
            args:{
                invoice_payment_number: {}
            }
        }
    }
}