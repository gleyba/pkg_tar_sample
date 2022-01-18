package tar_helper

import (
	"archive/tar"
	"fmt"
	"io"
	"os"
)

func CreateTarball(output string, directory string, filePaths map[string]string) error {
	file, err := os.Create(output)
	if err != nil {
		return fmt.Errorf("could not create tarball file '%s', got error '%w'", output, err)
	}
	defer file.Close()

	tarWriter := tar.NewWriter(file)
	defer tarWriter.Close()

	for srcPath, dstRelPath := range filePaths {
		err := addFileToTarWriter(srcPath, fmt.Sprintf("%s/%s", directory, dstRelPath), tarWriter)
		if err != nil {
			return fmt.Errorf("could not add file '%s', to tarball, got error '%w'", srcPath, err)
		}
	}

	return nil
}

// Private methods

func addFileToTarWriter(srcPath string, dstPath string, tarWriter *tar.Writer) error {
	file, err := os.Open(srcPath)
	if err != nil {
		return fmt.Errorf("could not open file '%s', got error '%w'", srcPath, err)
	}
	defer file.Close()

	stat, err := file.Stat()
	if err != nil {
		return fmt.Errorf("could not get stat for file '%s', got error '%w'", srcPath, err)
	}

	header := &tar.Header{
		Name:    dstPath,
		Size:    stat.Size(),
		Mode:    int64(stat.Mode()),
		ModTime: stat.ModTime(),
	}

	err = tarWriter.WriteHeader(header)
	if err != nil {
		return fmt.Errorf("could not write header for file '%s', got error '%w'", srcPath, err)
	}

	_, err = io.Copy(tarWriter, file)
	if err != nil {
		return fmt.Errorf("could not copy the file '%s' data to the tarball, got error '%w'", srcPath, err)
	}

	return nil
}
