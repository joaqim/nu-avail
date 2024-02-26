use ../avail/mod.nu *

use std assert

export def "Can use 'resources $resources' completions" [] {
    assert equal (available resources 'resources') ([invoices, invoicepayments])
    assert equal (available resources 'resources invoice') ([invoices, invoicepayments])
    #assert equal (available resources 'resources invoices') ([invoices, invoicepayments])
}

export def "Can use 'invoices $actions' completions" [] {
    assert equal (available actions 'resources invoices') ([put, post, get])
    assert equal (available actions 'resources invoices p') ([put, post])
    assert equal (available actions 'resources invoices pu') ([put])
    assert equal (available actions 'resources invoices put') ([put])
}

export def "Can use 'invoices --filter' completions" [] {
    assert equal (available filter 'resources invoices --filter') ([unbooked cancelled fullypaid unpaid unpaidoverdue])
    assert equal (available filter 'resources invoices --filter un') ([unbooked unpaid unpaidoverdue])
    assert equal (available filter 'resources invoices --filter paid') ([fullypaid unpaid unpaidoverdue])

}

export def test_ing [] {
    assert equal (recurse resources "resources") ([invoices, invoicepayments])
    assert equal (recurse resources "resources inv") ([invoices, invoicepayments])
    assert equal (recurse resources "resources invoicepay") ([invoicepayments])
    assert equal (recurse resources "resources invoicepayments") ([args])

    assert equal (recurse resources "resources invoices actions") (['put', 'post', 'get'])
    assert equal (recurse resources "resources invoices actions put") (['update', 'create'])

    assert equal (recurse resources 'resources invoices --filter') ([unbooked cancelled fullypaid unpaid unpaidoverdue])
    assert equal (recurse resources 'resources invoices --filter un') ([unbooked unpaid unpaidoverdue])
    assert equal (recurse resources 'resources invoices --filter paid') ([fullypaid unpaid unpaidoverdue])
    assert equal (recurse resources 'resources invoices --filter book') ([unbooked])

    assert equal (recurse resources 'resources invoices args --from-date') ([now])
    assert equal (recurse resources 'resources invoices args --from') (['12 days ago', '1 month ago', '1 year ago'])
    assert equal (recurse resources 'resources invoices args --from' | each {|| into datetime} | describe) ('list<date> (stream)')
}


use std log

export def test_completions [] {

    def 'avail resources' [$context: string] {
        log info ($context)
        (recurse 'resources' $context)
    }
    def 'avail actions' [$context: string] {
        log info ($context)
        (recurse 'resources' $context)
    }

    def my_func [
        $resources: string@'avail resources'
        $actions: string@'avail actions' = ''
        ] {
        (recurse resources $"resources ($resources) actions ($actions)")
    }

    assert equal (my_func inv) (['invoices', 'invoicepayments'])
    assert equal (my_func invoices) (['put', 'post', 'get'])
    assert equal (my_func invoices p) (['put', 'post'])
    assert equal (my_func invoices g) (['get'])
    assert equal (my_func invoices x) ([])

}