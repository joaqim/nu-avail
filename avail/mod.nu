
use ../resources_param_config.nu *

use std log

export def recurse [$conf_key: string, $context: string, --conf: any] {
    let $params = ($context | split row --regex \s+)

    let $resources_name = $params.1?

    log info ([$conf_key $resources_name, $context] | to nuon)
    

    let $last_param = (
        if (($params | last ) =~ '^--') {
            ($params | last | split words | str join '-') 
        } else {
            ($params | last)
        }
    )
    let $resources_conf = (($conf | default $resources_param_config) | get -i $conf_key)


    if  not ($resources_name | is-empty) and not ($resources_conf | is-empty) {
        if ($params.1? in ($resources_conf | columns)) {
            return (recurse $params.1  ($params | skip 1 | str join ' ') --conf ( $resources_conf))
        }
    }

    mut $completions = []

    if ($resources_conf | is-empty) {
        $completions = ($resources_param_config | columns)
    } else if (($resources_conf | describe) == 'list<string>') {
        $completions = ($resources_conf)
    } else {
        $completions = ($resources_conf | columns)
    }

    if ($last_param == $conf_key) {
        return ($completions | filter { $in != 'all'})
        #recurse $resources_name $context --conf $resources_conf
    }   

    return ($completions | filter { $in =~ $last_param})
    #return ($completions)
}

export def available [$arg_type: string, $context: string] {
    if ($arg_type == 'resources') { return ($resources_param_config.resources | reject -i all | columns) }
    let $params = ($context | split row --regex \s+)

    let $resources_name = $params.1
    let $last_param = (
        if (($params | last ) =~ '^--') {
            ($params | last | split words | str join '-') 
        } else {
            ($params | last)
        }
    )

    log info ([$arg_type $resources_name $context, $last_param] |to nuon)
    if ($resources_name == null) or ($arg_type == null) {
        return ($resources_param_config.resources | reject -i all | columns | filter { $in =~ $last_param})
    }

    let $resource_conf = ($resources_param_config.resources | get -i $resources_name)

    if ($resource_conf | is-empty) { #or (not ($arg_type in $resource_conf)) {
        if ($resources_name == $last_param) {
            return []
        }
        return ($resources_param_config.resources | columns | filter { $in =~ $last_param})
    }

    let $arg_conf = ($resource_conf | get -i $arg_type)

    print ($resource_conf | to nuon)
    print ($arg_conf | to nuon)
    print ($arg_conf | describe)
    if ($arg_conf | is-empty) { return ($resource_conf | columns) }

    mut $completions = []

    if (($arg_conf | describe) == 'list<string>') {
        $completions = ($arg_conf)
    } else {
        $completions = ($arg_conf | columns)
    }

    log info ($last_param | to nuon)
    log info ($completions | to nuon)
    if ($resources_name == $last_param) or ($arg_type == $last_param) {
        return ($completions | filter { $in != all})
    }

    #if (($completions | describe) == 'list<string>') {
    return ($completions | filter { $in =~ $last_param})
    

    #return ($resource_conf | get -i $arg_type | reject -i all | columns | filter { $in =~ $last_param})
}

export def 'available resources' [$context: string] {
    (available 'resources' $context)
}

export def 'available actions' [$context: string] {
    (available 'actions' $context)
}

export def 'available dates' [$context: string] {
    (available 'dates' $context)
}

export def 'available args' [$context: string] {
    (available 'args' $context)
}

export def 'available filter' [$context: string] {
    (available 'filter' $context)
}

export def 'available sort-by' [$context: string] {
    (available 'sort-by' $context)
}
