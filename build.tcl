#!/usr/bin/tclsh
package require struct::graph

struct::graph g

proc rule {input output command} {
	if ![g node exists $input] {g node insert $input}
	if ![g node exists $output] {g node insert $output}
	set arc [g arc insert $input $output]
	g arc set $arc command $command
}

source Buildfile

proc build {target} {
	foreach dependency [g arcs -in $target] {
		set input [g arc source $dependency]
		set output $target
		if ![file exists $input] then {
			build $input
		}
		eval [g arc get $dependency command]
	}
}

if {[llength $argv] == 0} then {
	foreach node [g nodes] {
		if {[g node degree -in $node] > 0} then {puts $node}
	}
} else {
	foreach target $argv {
		build $target
	}
}
