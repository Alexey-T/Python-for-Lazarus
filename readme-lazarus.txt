2 issues: Lazarus 1.5 trunk, fpc 2.6.4

- OSX: fpc cannot compile code, it yells about GetThreadID type not ok for Longint.
  Fix it: cast GetThreadID to PtrInt
  (Other OSes: all ok)
 
- all OS: IDE cannot compile itself with package (unit not found). 
  To fix: open package options, in the tab with Unit/Include/Object/etc set field "Unit":
  $(PkgOutDir)

Alex
