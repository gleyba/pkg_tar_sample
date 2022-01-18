package main

import (
	"github.com/jessevdk/go-flags"

	"github.com/gleyba/pkg_tar_sample/pkg/tar_helper"
)

var opts struct {
	Output    string            `long:"output" required:"yes" description:"Output tar file path"`
	Files     map[string]string `long:"file" required:"yes" description:"A map from file path to path inside tar"`
	Directory string            `long:"directory" default:"/" description:"The directory in which to expand the specified files, defaulting to '/'."`
}

func main() {
	_, err := flags.Parse(&opts)

	if err != nil {
		panic(err)
	}

	err = tar_helper.CreateTarball(opts.Output, opts.Directory, opts.Files)
	if err != nil {
		panic(err)
	}
}
