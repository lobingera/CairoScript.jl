# CairoScript

[![Build Status](https://travis-ci.org/lobingera/CairoScript.jl.svg?branch=master)](https://travis-ci.org/lobingera/CairoScript.jl)

[![Coverage Status](https://coveralls.io/repos/lobingera/CairoScript.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/lobingera/CairoScript.jl?branch=master)

[![codecov.io](http://codecov.io/github/lobingera/CairoScript.jl/coverage.svg?branch=master)](http://codecov.io/github/lobingera/CairoScript.jl?branch=master)

This package provides an interface to the cairo script interpreter.
The cairo script interpreter is actually a part of the libcairo development infrastructure and provided for debugging and performance evaluation purposes. CairoScript is a simple PostScript-like description language in ASCII form for cairo drawing operations. CairoScript can be output by choosing a special surface in Cairo; this package provides playback of scripts created.

Example (file "a1.cs"):
```
%!CairoScript
<< /content //COLOR_ALPHA /width 400 /height 300 >> surface context
1 1 0 rgb set-source
paint
/target get (out.png) write-to-png pop
pop
```
Will output a 400x300 pixel out.png in pure RGB yellow.

# API
To get to a consistent naming scheme and following the library names with the prefix e.g. `cairo_script_interpreter_run` are used with the module name CairoScript as prefix and lower case-> `CairoScript.interpreter_run()` while data types get upper case -> `CairoScript.InterpreterHooks()`

NOTE: this is work-in-progress and might get API changes.