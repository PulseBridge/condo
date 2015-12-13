---
layout: docs
title: copy
group: shades
---

@{/*

copy
    Copies one or more files from the source path to the destination path.

copy_src_path=''
    Required. The path from which to copy files.

copy_dst_path=''
    Required. The path to which to copy files.

copy_include='**&#47;*.*'
    Optional. The filter used to include files within the specified source path.

copy_exclude=''
    Optional. The filter used to exclude files within the specified source path.

copy_overwrite='false'
    Optional. A value indicating whether or not to overwrite existing files.

*/}

use namespace = 'System'
use namespace = 'System.IO'

use import = 'Files'

default copy_src_path   = ''
default copy_dst_path   = ''
default copy_include    = '**/*.*'
default copy_exclude    = ''
default copy_overwrite  = '${ false }'
default copy_flatten    = '${ false }'

@{
    Build.Log.Header("copy");

    if (string.IsNullOrEmpty(copy_src_path))
    {
        throw new ArgumentException("copy: the source path must be specified.", "copy_src_path");
    }

    if (string.IsNullOrEmpty(copy_dst_path))
    {
        throw new ArgumentException("copy: the destination path must be specified.", "copy_dst_path");
    }

    if (File.Exists(copy_src_path))
    {
        copy_include = Path.GetFileName(copy_src_path);
        copy_src_path = Path.GetDirectoryName(Path.GetFullPath(copy_src_path));
    }

    Build.Log.Argument("source", copy_src_path);
    Build.Log.Argument("destination", copy_dst_path);
    Build.Log.Argument("include", copy_include);
    Build.Log.Argument("exclude", copy_exclude);
    Build.Log.Argument("overwrite", copy_overwrite);
    Build.Log.Argument("flatten", copy_flatten);
    Build.Log.Header();

    var copy_files = Files.BasePath(copy_src_path);

    if (!string.IsNullOrEmpty(copy_include))
    {
        copy_files = copy_files.Include(copy_include);
    }

    if (!string.IsNullOrEmpty(copy_exclude))
    {
        copy_files = copy_files.Exclude(copy_exclude);
    }

    foreach(var copy_file in copy_files)
    {
        var copy_src_file = Path.Combine(copy_src_path, copy_file);
        var copy_dst_file = Path.Combine(copy_dst_path, copy_flatten ? Path.GetFileName(copy_file) : copy_file);

        Directory.CreateDirectory(Path.GetDirectoryName(copy_dst_file));

        File.Copy(copy_src_file, copy_dst_file, copy_overwrite);
    }
}