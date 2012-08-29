#!/usr/bin/python
# Run with directory arguments from any directory, with no special setup required.

import ftplib
import hashlib
import os
import re
import shutil
import string
import subprocess
import sys
import tarfile
import tempfile

def IsUninteresting(path):
    path = path.lower()
    if path.endswith(".mk") or path.endswith(".py") or path.endswith(".pyc") or path.endswith(".txt") or path.endswith(".3"):
        return True
    if path.endswith("/notice") or path.endswith("/readme") or path.endswith("/caveats"):
        return True
    if path.endswith("/zoneinfo.dat") or path.endswith("/zoneinfo.idx") or path.endswith("/zoneinfo.version") or path.endswith("/zoneinfo/generate"):
        return True
    return False

def IsAutoGenerated(content):
    if "generated by gensyscalls.py" in content or "generated by genserv.py" in content:
        return True
    if "This header was automatically generated from a Linux kernel header" in content:
        return True
    return False

copyrights = set()

def ExtractCopyrightAt(lines, i):
    hash = lines[i].startswith("#")

    # Do we need to back up to find the start of the copyright header?
    start = i
    if not hash:
        while start > 0:
            if "/*" in lines[start - 1]:
                break
            start -= 1

    # Read comment lines until we hit something that terminates a
    # copyright header.
    while i < len(lines):
        if "*/" in lines[i]:
            break
        if hash and len(lines[i]) == 0:
            break
        if "\t@(#)" in lines[i] or "\tfrom: @(#)" in lines[i] or "From: @(#)" in lines[i] or "from OpenBSD:" in lines[i]:
            break
        if "\tcitrus Id: " in lines[i]:
            break
        if "\t$OpenBSD: " in lines[i] or " $FreeBSD: " in lines[i] or "\t$NetBSD: " in lines[i]:
            break
        if "$FreeBSD$" in lines[i] or "$Citrus$" in lines[i]:
            break
        i += 1

    end = i

    # Trim trailing cruft.
    while end > 0:
        if lines[end - 1] != " *" and lines[end - 1] != " * ====================================================":
            break
        end -= 1

    # Remove C/assembler comment formatting, pulling out just the text.
    clean_lines = []
    for line in lines[start:end]:
        line = line.replace("\t", "    ")
        line = line.replace("/* ", "")
        line = line.replace(" * ", "")
        line = line.replace("** ", "")
        line = line.replace("# ", "")
        if line.startswith("++Copyright++"):
            continue
        line = line.replace("--Copyright--", "")
        line = line.rstrip()
        # These come last and take care of "blank" comment lines.
        if line == "#" or line == " *" or line == "**" or line == "-":
            line = ""
        clean_lines.append(line)

    # Trim blank lines from head and tail.
    while clean_lines[0] == "":
        clean_lines = clean_lines[1:]
    while clean_lines[len(clean_lines) - 1] == "":
        clean_lines = clean_lines[0:(len(clean_lines) - 1)]

    copyright = "\n".join(clean_lines)
    copyrights.add(copyright)

    return i

args = sys.argv[1:]
if len(args) == 0:
    args = [ "." ]

for arg in args:
    sys.stderr.write('Searching for source files in "%s"...\n' % arg)

    for directory, sub_directories, filenames in os.walk(arg):
        if ".git" in sub_directories:
            sub_directories.remove(".git")
        sub_directories = sorted(sub_directories)

        for filename in sorted(filenames):
            path = os.path.join(directory, filename)
            if IsUninteresting(path):
                #print "ignoring uninteresting file %s" % path
                continue

            try:
                content = open(path, 'r').read().decode('utf-8')
            except:
                # TODO: update hash.h, md5.c, and md5.h; upstream is probably UTF-8 already.
                sys.stderr.write('warning: bad UTF-8 in %s\n' % path)
                content = open(path, 'r').read().decode('iso-8859-1')

            lines = content.split("\n")

            if len(lines) <= 4:
                #print "ignoring short file %s" % path
                continue

            if IsAutoGenerated(content):
                #print "ignoring auto-generated file %s" % path
                continue

            if not "Copyright" in content:
                if "public domain" in content.lower():
                    #print "ignoring public domain file %s" % path
                    continue
                sys.stderr.write('warning: no copyright notice found in "%s" (%d lines)\n' % (path, len(lines)))
                continue

            i = 0
            while i < len(lines):
                if "Copyright" in lines[i]:
                    i = ExtractCopyrightAt(lines, i)
                i += 1

            #print path

for copyright in sorted(copyrights):
    print copyright.encode('utf-8')
    print
    print '-------------------------------------------------------------------'
    print

sys.exit(0)
